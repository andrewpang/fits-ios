//
//  AddPostView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import FirebaseAuth
import Amplitude
import UniformTypeIdentifiers
import Mixpanel

struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var mediaItems: PickedMediaItems
    @ObservedObject var homeViewModel: HomeViewModel
    
    @EnvironmentObject var tabViewModel: TabViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var promptModel: PromptModel?
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                if (postViewModel.postType == Constants.postTypePrompt) {
                    if let promptModel = promptModel {
                        HStack {
                            Spacer()
                            Text(promptModel.title ?? "")
                                .font(Font.custom(Constants.titleFontBold, size: 24))
                                .multilineTextAlignment(.center)
                            Spacer()
                        }.padding(.bottom, 8)
                        .padding(.horizontal)
                    }
                }
                Group {
                    if (mediaItems.items.count > 1) {
                        Text("Photos:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    } else {
                        Text("Photo:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(mediaItems.items.indices, id: \.self) { index in
                                ZStack {
                                    Image(uiImage: mediaItems.items[index].photo ?? UIImage())
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, 10)
                                        .padding(.trailing, 10)
                                        .frame(maxHeight: 250)
                                    if (mediaItems.items.count > 1) {
                                        RemoveButton(indexOfImage: index, mediaItems: mediaItems, postViewModel: postViewModel)
                                    }
                                }
                            }
                        }
                    }.frame(maxHeight: 250)
                    if (postViewModel.postType == "intro") {
                        Text("Post Title:")
                            .font(Font.custom(Constants.titleFontBold, size: 16)) +
                        Text(" (think of this as a headline)")
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .foregroundColor(.gray)
                    } else if (postViewModel.postType == "productreview") {
                        Text("Post Title:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                        Text("Suggested: Item Name + Brand")
                            .font(Font.custom(Constants.bodyFont, size: 12))
                    } else {
                        Text("Post Title:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    }
                    
                    Text("Required (Max. 30 Characters)")
                        .font(Font.custom(Constants.bodyFont, size: 12))
                        .foregroundColor(.gray)
                    TextField("Title", text: $postViewModel.postTitle)
                        .font(Font.custom(Constants.titleFont, size: 16))
                        .disabled(postViewModel.isSubmitting)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(postViewModel.postTitle.publisher.collect()) {
                            let s = String($0.prefix(Constants.postTitleCharacterLimit))
                            if postViewModel.postTitle != s {
                                postViewModel.postTitle = s
                            }
                          }
                }.padding(.horizontal)
                
                Group {
                    Text("Tags:")
                        .font(Font.custom(Constants.titleFontBold, size: 16))
                        .padding(.horizontal)
                    Text("Optional (More tags coming soon)")
                        .font(Font.custom(Constants.bodyFont, size: 12))
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                    TagsView()
                }
                
                Group {
                    if (postViewModel.postType == "productreview") {
                        Text("Rating:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                        Text("Required")
                            .font(Font.custom(Constants.bodyFont, size: 12))
                            .foregroundColor(.gray)
                        ClickableStarsView(rating: $postViewModel.postRating).padding(.bottom, 4)
                    }
                    if (postViewModel.postType == "intro") {
                        Text("Note:")
                            .font(Font.custom(Constants.titleFontBold, size: 16)) +
                        Text(" (see recommended details below)")
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .foregroundColor(.gray)
                    } else if (postViewModel.postType == "productreview") {
                        Text("Review:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    } else {
                        Text("Note:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    }
                }.padding(.horizontal)
                
                Group {
                    Text("Required (Max. 500 Characters)")
                        .font(Font.custom(Constants.bodyFont, size: 12))
                        .foregroundColor(.gray)
                    ZStack {
                        TextEditor(text: $postViewModel.postBody)
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .disabled(postViewModel.isSubmitting)
                        Text(postViewModel.postBody).opacity(0).padding(.all, 8)
                            .font(Font.custom(Constants.bodyFont, size: 16))
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray).opacity(0.3))
                    .frame(minHeight: 100)
    //                TextEditor(text: $postViewModel.postBody)
    //                    .font(Font.custom(Constants.bodyFont, size: 16))
    //                    .overlay(RoundedRectangle(cornerRadius: 8)
    //                        .stroke(Color.gray).opacity(0.3))
    //                    .frame(minHeight: 150)
                    Text("Recommended Details:")
                        .font(Font.custom(Constants.bodyFont, size: 18))
                    Text(postViewModel.recommendedDetails)
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 40)
                }.padding(.horizontal)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    let eventName = "Submit Post - Clicked"
                    let propertiesDict = ["postType": postViewModel.postType as String, "postTitleLength": postViewModel.postTitle.count, "postBodyLength": postViewModel.postBody.count, "promptId": promptModel?.id] as? [String : Any]
                    let propertiesDictMixpanel = ["postType": postViewModel.postType as String, "postTitleLength": postViewModel.postTitle.count, "postBodyLength": postViewModel.postBody.count, "promptId": promptModel?.id] as? [String : MixpanelType]
                    Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                    Mixpanel.mainInstance().track(event: eventName, properties: propertiesDictMixpanel)
//                TODO: Change this logic once there are more non-FIT groups
                    let groupId = authenticationViewModel.userModel?.groups?.first ?? Constants.FITGroupId
                    var postPromptMap: PostPromptMap? = nil
                    if let promptModel = promptModel {
                        postPromptMap = PostPromptMap(title: promptModel.title, promptId: promptModel.id, endTime: promptModel.endTime)
                    }
                    postViewModel.submitPost(mediaItems: mediaItems, postAuthorMap: authenticationViewModel.getPostAuthorMap(), groupId: groupId, prompt: postPromptMap) {
                        postViewModel.shouldPopToRootViewIfFalse = false
                        homeViewModel.shouldPopToRootViewIfFalse = false
                        homeViewModel.setIntroPostMade()
                        if (postViewModel.postType == Constants.postTypePrompt) {
                            //Dismiss for now, instead of popping to root
                            presentationMode.wrappedValue.dismiss()
                            homeViewModel.fetchPosts(isAdmin: authenticationViewModel.userModel?.groups?.contains(Constants.adminGroupId) ?? false)
                            homeViewModel.fetchPromptPostsForUser(with: authenticationViewModel.userModel?.id ?? "")
                        } else {
                            homeViewModel.shouldScrollToTopMostRecent = true
                            tabViewModel.tabSelection = 1
                            homeViewModel.currentTab = homeViewModel.mostRecentTab
                            homeViewModel.fetchPosts(isAdmin: authenticationViewModel.userModel?.groups?.contains(Constants.adminGroupId) ?? false)
                            homeViewModel.fetchPromptPostsForUser(with: authenticationViewModel.userModel?.id ?? "")
                        }
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    if (shouldDisablePostButton()) {
                        HStack {
                           Text("Post")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(0.75)
                    } else {
                        HStack {
                            if (postViewModel.isSubmitting) {
                                Text("Loading...")
                                    .font(Font.custom(Constants.bodyFont, size: 16))
                            } else {
                                Text("Post")
                                    .font(Font.custom(Constants.bodyFont, size: 16))
                            }
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .disabled(shouldDisablePostButton())
            }
        }
        .onAppear {
            let eventName = "Add Post Screen - View"
            let propertiesDict = ["postType": postViewModel.postType as Any] as? [String : String]
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
        }
        .onDisappear {
            mediaItems.deleteAll()
            self.postViewModel.isSubmitting = false
        }
    }
    
    func shouldDisablePostButton() -> Bool {
        if (postViewModel.postType == "productreview" && self.postViewModel.postRating == nil) {
            return true
        }
        return self.postViewModel.isSubmitting || self.postViewModel.postTitle.isEmpty || self.postViewModel.postBody.isEmpty
    }
}

struct RemoveButton: View {
    var indexOfImage: Int
    @ObservedObject var mediaItems: PickedMediaItems
    @ObservedObject var postViewModel: PostViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    mediaItems.remove(at: indexOfImage)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 18.0))
                        .background(Color.black)
                        .clipShape(Circle())
                }.disabled(postViewModel.isSubmitting)
            }
            Spacer()
        }
    }
}
//struct AddPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPostView(homeViewModel: <#T##HomeViewModel#>, authenticationViewModel: <#T##AuthenticationViewModel#>, pickerResult: <#T##Binding<UIImage>#>)
//    }
//}
