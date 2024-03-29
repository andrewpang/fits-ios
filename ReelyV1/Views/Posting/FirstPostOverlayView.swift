//
//  FirstPostOverlayView.swift
//  FITs
//
//  Created by Andrew Pang on 7/12/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel

struct FirstPostOverlayView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @StateObject var postViewModel = PostViewModel()
    @StateObject var mediaItems = PickedMediaItems()
    
    @State var showPicker = false
    @State var showConfirmationDialog = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.75)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink(destination: AddPostView(postViewModel: postViewModel, mediaItems: mediaItems, homeViewModel: homeViewModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                    EmptyView()
                }
                .isDetailLink(false)
                VStack {
                    Button(action: {
                        homeViewModel.showIntroPostOverlay = false
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark.circle")
                                .foregroundColor(Color.black)
                        }
                    })
                    .padding(.horizontal, 24)
                    Text("Share your fit!")
                        .font(Font.custom(Constants.titleFont, size: 32))
                        .foregroundColor(Color.black)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 24)
                    Text("Let's help you post your first outfit pic to let the FIT(s) community know you've joined!")
                        .font(Font.custom(Constants.bodyFont, size: 18))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    KFAnimatedImage(URL(string: Constants.firstPostGifUrl))
                        .scaledToFit()
                        .cornerRadius(Constants.buttonCornerRadius)
                        .padding(.horizontal, 24)
                    Spacer()
                    Text("Step 1: Choose an outfit pic that gives us a sense of your style")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    Button(action: {
                        postViewModel.resetData()
                        showConfirmationDialog = true
                        postViewModel.postType = "intro"
                    }, label: {
                        HStack {
                            Text("Choose Photo")
                                .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                                .foregroundColor(.black)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                        .background(Color(Constants.onBoardingButtonColor))
                        .foregroundColor(.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .padding(.horizontal, 40)
                    })
                    .padding(.vertical, 8)
                    Button(action: {
                        homeViewModel.showIntroPostOverlay = false
                    }, label: {
                        Text("Skip for now")
                            .font(Font.custom(Constants.bodyFont, size: 14))
                            .foregroundColor(.gray)
                    })
                }
                .padding(.vertical, 40)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
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
                }
                .onAppear {
                    let eventName = "First Post Overlay - View"
                    Amplitude.instance().logEvent(eventName)
                    Mixpanel.mainInstance().track(event: eventName)
                }
                .sheet(isPresented: $showPicker) {
                    if (sourceType == .camera) {
                        UIImagePicker(selectedImage: $postViewModel.postImage, isPresented: $showPicker, sourceType: sourceType).onDisappear {
                            if (postViewModel.postImage != nil) {
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
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
}

//struct FirstPostOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstPostOverlayView()
//    }
//}
