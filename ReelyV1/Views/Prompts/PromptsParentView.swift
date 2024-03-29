//
//  PromptsParentView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI
import Amplitude
import Mixpanel
import Firebase

struct PromptsParentView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var promptsViewModel: PromptsViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @StateObject var postViewModel = PostViewModel()
    @StateObject var mediaItems = PickedMediaItems()
    @State var selectedPromptModel: PromptModel = PromptModel(title: "") //Initial default value
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: AddPostView(postViewModel: postViewModel, mediaItems: mediaItems, homeViewModel: homeViewModel, promptModel: selectedPromptModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                NavigationLink(destination:
                                PromptDetailView(promptDetailViewModel: PromptDetailViewModel(promptModel: selectedPromptModel, promptPostModel: promptsViewModel.promptIdToPostPromptMapDictionary[selectedPromptModel.id ?? "noID"]), homeViewModel: homeViewModel)
                                        .accentColor(Color(Constants.backgroundColor)),
                               isActive: $promptsViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                
                Text("Fit Check")
                    .font(Font.custom(Constants.titleFontBold, size: 36))
                    .padding(.top, 16)
                Text("Every Sunday, we'll release a new FIT CHECK theme to post to! Participate to see other people's posts")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                if let promptModels = promptsViewModel.promptsData.promptModels, !promptModels.isEmpty {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(promptModels, id: \.id) { promptModel in
                                if (promptModel.promptHasNotStarted()) {
                                    //Don't add anything
                                } else {
                                    Button(action: {
                                        selectedPromptModel = promptModel
                                        if (promptsViewModel.hasCurrentUserPostedToPrompt(with: promptModel.id) || promptModel.promptHasAlreadyEnded()) {
                                            promptsViewModel.shouldPopToRootViewIfFalse = true
                                        } else {
                                            postViewModel.resetData()
                                            showConfirmationDialog = true
                                            postViewModel.postType = Constants.postTypePrompt
                                        }
                                    }) {
                                        PromptRowView(promptsViewModel: promptsViewModel, promptModel: promptModel)
                                            .padding(.bottom, 8)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    Text("Sorry, there's no prompts at the moment :(")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                        .padding(16)
                }
//                Text(challengesViewModel.challengesData.challengeModels?[0].title ?? "hi")
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.horizontal, 16)
        }.navigationViewStyle(.stack)
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
        }.onAppear {
            promptsViewModel.fetchPrompts(userId: authenticationViewModel.userModel?.id ?? "")
            let eventName = "Prompts List Screen - View"
            Amplitude.instance().logEvent(eventName)
            Mixpanel.mainInstance().track(event: eventName)
        }.onDisappear {
            promptsViewModel.removeListeners()
        }
    }
}
