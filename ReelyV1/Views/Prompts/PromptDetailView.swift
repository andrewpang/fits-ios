//
//  PromptDetailView.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import SwiftUI

struct PromptDetailView: View {
    @ObservedObject var promptDetailViewModel: PromptDetailViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    
    @StateObject var postViewModel = PostViewModel()
    @StateObject var mediaItems = PickedMediaItems()
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        ZStack {
            NavigationLink(destination: AddPostView(postViewModel: postViewModel, mediaItems: mediaItems, homeViewModel: homeViewModel, promptModel: promptDetailViewModel.promptModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                EmptyView()
            }
            NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "themesFeed"), isActive: $promptDetailViewModel.detailViewIsActive) {
                EmptyView()
            }
            Color(Constants.backgroundColor).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(promptDetailViewModel.promptModel.title ?? "Prompt")
                        .font(Font.custom(Constants.titleFontBold, size: 24))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal, 8)

                Button(action: {
                    postViewModel.resetData()
                    showConfirmationDialog = true
                    postViewModel.postType = Constants.postTypePrompt
                }) {
                    HStack {
                        if (promptDetailViewModel.promptModel.promptHasAlreadyEnded()) {
                            Text("This fit check has already ended")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(Color(Constants.backgroundColor))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                        } else if (promptDetailViewModel.userHasPostedInLastDay()) {
                            Text("Wait until tomorrow to post again")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(Color(Constants.backgroundColor))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                        } else {
                            Text("Contribute your fit")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(Color(Constants.backgroundColor))
                                .padding(.vertical, 16)
                                .padding(.horizontal, 24)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
                    .background(Color("FITColor"))
                    .cornerRadius(Constants.buttonCornerRadius)
                    .padding(.horizontal, 60)
                }.disabled(promptDetailViewModel.promptModel.promptHasAlreadyEnded() || promptDetailViewModel.userHasPostedInLastDay())
                .padding(16)
                
                Text("*You can post once a day until the prompt ends")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                
                HStack {
                    Text("Posts:")
                        .font(Font.custom(Constants.titleFontBold, size: 24))
                    Spacer()
                }.padding(.horizontal, 8)
                .padding(.vertical, 8)
               
//                if let postModels = promptDetailViewModel.postsData.postModels, !postModels.isEmpty {
//                    //
//                } else {
//                    Text("There's no posts yet, be the first to post!")
//                        .font(Font.custom(Constants.bodyFont, size: 24))
//                        .padding(.vertical, 40)
//                }
                WaterfallPromptCollectionView(promptDetailViewModel: promptDetailViewModel, postDetailViewModel: $postDetailViewModel, uiCollectionViewController: UICollectionViewController())
            }
        }.navigationBarTitle("", displayMode: .inline)
        .confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
            let eventName = "Post Categories Dialog - Clicked"
            Button ("Photo Library") {
                self.showPicker = true
                self.sourceType = .photoLibrary
                let propertiesDict = ["selection": "photoLibrary", "postType": postViewModel.postType] as? [String : String]
//                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
            Button ("Camera") {
                self.showPicker = true
                self.sourceType = .camera
                let propertiesDict = ["selection": "camera", "postType": postViewModel.postType] as? [String : String]
//                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
            Button ("Cancel", role: ButtonRole.cancel) {
                let propertiesDict = ["selection": "cancel", "postType": postViewModel.postType] as? [String : String]
//                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
        } message: {
            Text ("Choose a picture from your photo library, or take one now!")
        }.sheet(isPresented: $showPicker) {
            if (sourceType == .camera) {
                UIImagePicker(selectedImage: $postViewModel.postImage, isPresented: $showPicker, sourceType: sourceType).onDisappear {
                    if (postViewModel.postImage != nil) {
                        self.mediaItems.append(item: PhotoPickerModel(with: postViewModel.postImage))
                        self.postViewModel.postTags = [postViewModel.postType]
                        self.postViewModel.shouldPopToRootViewIfFalse = true
                    }
                }
            } else {
                PHImagePicker(mediaItems: mediaItems) { didSelectItem in
                    showPicker = false
                    if (didSelectItem) {
                        self.postViewModel.postTags = [postViewModel.postType]
                        self.postViewModel.shouldPopToRootViewIfFalse = true
                    }
                }
            }
        }
        .onAppear {
            promptDetailViewModel.fetchPostsForPrompt()
        }.onDisappear {
            promptDetailViewModel.resetData()
            promptDetailViewModel.removeListeners()
        }
    }
}
