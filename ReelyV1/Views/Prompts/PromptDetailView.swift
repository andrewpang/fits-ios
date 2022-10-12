//
//  PromptDetailView.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import SwiftUI
import Amplitude
import Mixpanel

struct PromptDetailView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var promptDetailViewModel: PromptDetailViewModel
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
            }.isDetailLink(false)
            NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "themesFeed"), isActive: $promptDetailViewModel.detailViewIsActive) {
                EmptyView()
            }.isDetailLink(false)
            Color(Constants.backgroundColor).ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Fit Check")
                        .font(Font.custom(Constants.titleFontItalicized, size: 18))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal, 8)
                HStack {
                    Spacer()
                    Text(promptDetailViewModel.promptModel.title ?? "Prompt")
                        .font(Font.custom(Constants.titleFontBold, size: 18))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.horizontal, 8)
                
                if let endTimeString = promptDetailViewModel.promptModel.getFormattedEndDateString() {
                    if (promptDetailViewModel.promptModel.promptHasAlreadyEnded()) {
                        if let startTimeString = promptDetailViewModel.promptModel.getFormattedStartDateString() {
                            Text("\(startTimeString) - \(endTimeString)")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                                .padding(.bottom, 16)
                                .padding(.horizontal, 16)
                        }
                    } else {
                        Text("Add new posts until: \(endTimeString)")
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                            .padding(.horizontal, 16)
                    }
                }

                if (!promptDetailViewModel.promptModel.promptHasAlreadyEnded()) {
                    Button(action: {
                        postViewModel.resetData()
                        showConfirmationDialog = true
                        postViewModel.postType = Constants.postTypePrompt
                    }) {
                        HStack {
                            if (promptDetailViewModel.userHasPostedInLastDay()) {
                                Text("Wait until tomorrow to post again")
                                    .font(Font.custom(Constants.buttonFont, size: 16))
                                    .foregroundColor(Color(Constants.backgroundColor))
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                            } else {
                                Text("Contribute your fit")
                                    .font(Font.custom(Constants.buttonFont, size: 16))
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
                }
                
                WaterfallPromptCollectionView(promptDetailViewModel: promptDetailViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController())
            }
        }.navigationBarTitle("", displayMode: .inline)
        .confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
            let eventName = "Post Categories Dialog - Clicked"
            Button ("Photo Library") {
                self.showPicker = true
                self.sourceType = .photoLibrary
                let propertiesDict = ["selection": "photoLibrary", "postType": postViewModel.postType] as? [String : String]
                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
            Button ("Camera") {
                self.showPicker = true
                self.sourceType = .camera
                let propertiesDict = ["selection": "camera", "postType": postViewModel.postType] as? [String : String]
                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
            }
            Button ("Cancel", role: ButtonRole.cancel) {
                let propertiesDict = ["selection": "cancel", "postType": postViewModel.postType] as? [String : String]
                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
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
            promptDetailViewModel.fetchPostLikesForUser(with: authenticationViewModel.userModel?.id ?? "noId")
            let propertiesDict = [
                "promptId": promptDetailViewModel.promptModel.id
            ] as? [String : String]
            let eventName = "Prompt Detail Screen - View"
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
        }.onDisappear {
            promptDetailViewModel.removeListeners()
        }
    }
}
