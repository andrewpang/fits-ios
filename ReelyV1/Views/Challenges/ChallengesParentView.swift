//
//  ChallengesParentView.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import SwiftUI
import Amplitude
import Mixpanel

struct ChallengesParentView: View {
    
    @StateObject var challengesViewModel = ChallengesViewModel()
    @StateObject var postViewModel = PostViewModel()
    @StateObject var mediaItems = PickedMediaItems()
    @ObservedObject var homeViewModel: HomeViewModel
    @State var selectedChallengeModel: ChallengeModel = ChallengeModel(title: "") //Initial default value
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationLink(destination: AddPostView(postViewModel: postViewModel, mediaItems: mediaItems, homeViewModel: homeViewModel, challengeModel: selectedChallengeModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                NavigationLink(destination: ChallengeDetailView(challengeDetailViewModel: ChallengeDetailViewModel(challengeModel: selectedChallengeModel), homeViewModel: homeViewModel), isActive: $challengesViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                
                Text("Weekly Challenges")
                    .font(Font.custom(Constants.titleFontBold, size: 36))
                Text("Every Sunday, we'll release a new challenge blah blah blah blah blah blah blah")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)
                if let challengeModels = challengesViewModel.challengesData.challengeModels, !challengeModels.isEmpty {
                    ScrollView {
                        LazyVStack {
                            ForEach(challengeModels, id: \.id) { challengeModel in
                                Button(action: {
                                    selectedChallengeModel = challengeModel
                                    challengesViewModel.shouldPopToRootViewIfFalse = true
                                    //If going to participate, show post
                                    //If not blurred, show challenge view
//                                    postViewModel.resetData()
//                                    challengesViewModel.selectedChallengeModel = challengeModel
//                                    showConfirmationDialog = true
//                                    postViewModel.postType = "challenge"
                                }) {
                                    ChallengesRowView(challengeModel: challengeModel)
                                        .padding(.bottom, 8)
                                }
                            }
                        }
                    }
                } else {
                    Text("Sorry, there's no challenges at the moment :(")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                        .padding(16)
                }
//                Text(challengesViewModel.challengesData.challengeModels?[0].title ?? "hi")
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.horizontal, 16)
        }.confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
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
        }.onAppear {
            challengesViewModel.fetchChallenges()
        }
    }
}
