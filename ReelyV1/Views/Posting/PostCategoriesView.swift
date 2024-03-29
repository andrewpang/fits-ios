//
//  PostCategoriesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/1/22.
//

import SwiftUI
import PermissionsSwiftUIPhoto
import PermissionsSwiftUICamera
import Amplitude
import Mixpanel

struct PostCategoriesView: View {
    @StateObject var postViewModel = PostViewModel()
    @StateObject var mediaItems = PickedMediaItems()
    @ObservedObject var homeViewModel: HomeViewModel
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var showPermissionsAlert = false
    
    var body: some View {
        ZStack {
            Color(Constants.backgroundColor).ignoresSafeArea()
            ScrollView {
                VStack {
                    NavigationLink(destination: AddPostView(postViewModel: postViewModel, mediaItems: mediaItems, homeViewModel: homeViewModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                        EmptyView()
                    }
                    .isDetailLink(false)
                    
                    Text("What do you want to share with the FIT(s) Community?")
                        .font(Font.custom(Constants.titleFontBold, size: 24))
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                    HStack {
                        Button(action: {
    //                        showPermissionsAlert = true
                            postViewModel.resetData()
                            showConfirmationDialog = true
                            postViewModel.postType = "ootd"
                        }, label: {
                            VStack {
                                Text("📸")
                                    .font(Font.system(size: 80))
                                Text("Fit Pic (OOTD)")
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.custom(Constants.titleFontBold, size: 24))
                                    .foregroundColor(.black)
                                Text("Show off your creativity and post your daily looks!")
                                    .multilineTextAlignment(.center)
                                    .font(Font.custom(Constants.bodyFont, size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 260)
                            .background(Color.white)
                            .cornerRadius(Constants.buttonCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        })
                        
                        Button(action: {
                            showPermissionsAlert = true
                            postViewModel.resetData()
                            showConfirmationDialog = true
                            postViewModel.postType = "productreview"
                        }, label: {
                            VStack {
                                Text("📝")
                                    .font(Font.system(size: 80))
                                Text("Product Review")
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.custom(Constants.titleFontBold, size: 24))
                                    .foregroundColor(.black)
                                Text("Share a review of any pieces in your closet!")
                                    .multilineTextAlignment(.center)
                                    .font(Font.custom(Constants.bodyFont, size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 260)
                            .background(Color.white)
                            .cornerRadius(Constants.buttonCornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: Constants.buttonCornerRadius)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        })
                    }
                    
                    Text("Coming Soon...")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                    
                    Group {
                        VStack {
                            Text("Text Post")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Post questions or discussions")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.75)
                        
                        VStack {
                            Text("Spotted")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Snap looks you’re spotting around town")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.75)
                        
                        VStack {
                            Text("Help Me Get Ready")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Post two outfits and let the community decide!")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.75)
                        
//                        VStack {
//                            Text("Thrifting")
//                                .font(Font.custom(Constants.titleFontBold, size: 16))
//                                .foregroundColor(.black)
//                            Text("What are you buying and where?")
//                                .multilineTextAlignment(.center)
//                                .font(Font.custom(Constants.bodyFont, size: 16))
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 24)
//                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
//                        .background(Color.white)
//                        .cornerRadius(Constants.buttonCornerRadius)
//                        .opacity(0.5)
//
//                        VStack {
//                            Text("Share Your Work")
//                                .font(Font.custom(Constants.titleFontBold, size: 16))
//                                .foregroundColor(.black)
//                            Text("Post things you’ve made or worked on")
//                                .multilineTextAlignment(.center)
//                                .font(Font.custom(Constants.bodyFont, size: 16))
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 24)
//                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
//                        .background(Color.white)
//                        .cornerRadius(Constants.buttonCornerRadius)
//                        .opacity(0.5)
                    }.confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
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
                    }
                }.padding(.horizontal, 24)
                .padding(.vertical, 8)
            }.navigationBarHidden(true)
            .sheet(isPresented: $showPicker) {
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
//            .JMAlert(showModal: $showPermissionsAlert, for: [.camera, .photo], autoDismiss: true)
            .onAppear {
                let eventName = "Post Categories Screen - View"
                Amplitude.instance().logEvent(eventName)
                Mixpanel.mainInstance().track(event: eventName)
            }
        }
    }
}
