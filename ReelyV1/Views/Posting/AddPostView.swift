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

struct AddPostView: View {
    @ObservedObject var postViewModel: PostViewModel
    @ObservedObject var mediaItems: PickedMediaItems
    @ObservedObject var homeViewModel: HomeViewModel
    
    @EnvironmentObject var tabViewModel: TabViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    let postTitleCharacterLimit = 30
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
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
                    } else {
                        Text("Post Title:")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                    }
                    
                    Text("Required (Max. 30 Characters)")
                        .font(Font.custom(Constants.bodyFont, size: 12))
                        .foregroundColor(.gray)
                    TextField("Title", text: $postViewModel.postTitle)
                        .font(Font.custom(Constants.titleFont, size: 16))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(postViewModel.postTitle.publisher.collect()) {
                            let s = String($0.prefix(postTitleCharacterLimit))
                            if postViewModel.postTitle != s {
                                postViewModel.postTitle = s
                            }
                          }
                }
                if (postViewModel.postType == "intro") {
                    Text("Note:")
                        .font(Font.custom(Constants.titleFontBold, size: 16)) +
                    Text(" (see recommended details below)")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                } else {
                    Text("Note:")
                        .font(Font.custom(Constants.titleFontBold, size: 16))
                }
                
                Text("Required (Max. 500 Characters)")
                    .font(Font.custom(Constants.bodyFont, size: 12))
                    .foregroundColor(.gray)
                ZStack {
                    TextEditor(text: $postViewModel.postBody)
                        .font(Font.custom(Constants.bodyFont, size: 16))
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
            }
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    let propertiesDict = ["postType": postViewModel.postType as Any, "postTitleLength": postViewModel.postTitle.count, "postBodyLength": postViewModel.postBody.count] as [String : Any]
                    Amplitude.instance().logEvent("Submit Post - Clicked", withEventProperties: propertiesDict)
//                TODO: Change this logic once there are more non-FIT groups
                    postViewModel.submitPost(mediaItems: mediaItems, postAuthorMap: authenticationViewModel.getPostAuthorMap(), groupId: Constants.FITGroupId) {
                        postViewModel.shouldPopToRootViewIfFalse = false
                        homeViewModel.shouldPopToRootViewIfFalse = false
                        homeViewModel.setIntroPostMade()
                        tabViewModel.tabSelection = 1
                        homeViewModel.fetchPosts(isAdmin: authenticationViewModel.userModel?.groups?.contains(Constants.adminGroupId) ?? false)
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    if (self.postViewModel.postTitle.isEmpty || self.postViewModel.postBody.isEmpty) {
                        HStack {
                           Text("Post")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color.red)
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
                .disabled(self.postViewModel.isSubmitting || self.postViewModel.postTitle.isEmpty || self.postViewModel.postBody.isEmpty)
            }
        }
        .onAppear {
            let propertiesDict = ["postType": postViewModel.postType as Any] as [String : Any]
            Amplitude.instance().logEvent("Add Post Screen - View", withEventProperties: propertiesDict)
        }
        .onDisappear {
            mediaItems.deleteAll()
            self.postViewModel.isSubmitting = false
        }
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
