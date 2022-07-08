//
//  PostCategoriesView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/1/22.
//

import SwiftUI
import PermissionsSwiftUIPhoto
import PermissionsSwiftUICamera

struct PostCategoriesView: View {
    @ObservedObject var postViewModel = PostViewModel()
    
    @State var showPicker = false
    @State var showSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var showPermissionsAlert = true
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
            ScrollView {
                VStack {
                    NavigationLink(destination: AddPostView(postViewModel: postViewModel), isActive: $postViewModel.shouldPopToRootViewIfFalse) {
                        EmptyView()
                    }
                    .isDetailLink(false)
                    
                    Text("What do you want to share with the FIT(s) Community?")
                        .font(Font.custom(Constants.titleFontBold, size: 24))
                        .foregroundColor(.black)
                        .padding(.bottom, 16)
                    
                    Button(action: {
                        postViewModel.resetData()
                        showSheet = true
                        postViewModel.postType = "ootd"
                    }, label: {
                        VStack {
                            Text("Fit Pic (OOTD)")
                                .font(Font.custom(Constants.titleFontBold, size: 24))
                                .foregroundColor(.black)
                            Text("Show off your creativity and post your daily looks!")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                    }).actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select Photo"), message: Text("Choose a fit pic from your photo library, or take one now!"), buttons: [
                            .default(Text("Photo Library")) {
                                self.showPicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                self.showPicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
                    }
                    
                    Button(action: {
                        postViewModel.resetData()
                        showSheet = true
                        postViewModel.postType = "productReview"
                    }, label: {
                        VStack {
                            Text("Product Review")
                                .font(Font.custom(Constants.titleFontBold, size: 24))
                                .foregroundColor(.black)
                            Text("Bought something new? Tell us about it!")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                    }).actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select Photo"), message: Text("Choose a product pic from your photo library, or take one now!"), buttons: [
                            .default(Text("Photo Library")) {
                                self.showPicker = true
                                self.sourceType = .photoLibrary
                            },
                            .default(Text("Camera")) {
                                self.showPicker = true
                                self.sourceType = .camera
                            },
                            .cancel()
                        ])
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
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.5)
                        
                        VStack {
                            Text("Spotted")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Snap looks you’re spotting around town")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.5)
                        
                        VStack {
                            Text("Help Me Get Ready")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Post two outfits and let the community decide!")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.5)
                        
                        VStack {
                            Text("Thrifting")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("What are you buying and where?")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.5)
                        
                        VStack {
                            Text("Share Your Work")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .foregroundColor(.black)
                            Text("Post things you’ve made or worked on")
                                .multilineTextAlignment(.center)
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.white)
                        .cornerRadius(Constants.buttonCornerRadius)
                        .opacity(0.5)
                    }
                }.padding(.horizontal, 24)
                .padding(.vertical, 8)
            }.navigationBarHidden(true)
            .sheet(isPresented: $showPicker) {
                ImagePicker(selectedImage: $postViewModel.postImage, isPresented: $showPicker, sourceType: sourceType).onDisappear {
                    if (postViewModel.postImage != nil) {
                        self.postViewModel.postTags = [postViewModel.postType]
                        self.postViewModel.shouldPopToRootViewIfFalse = true
                    }
                }
            }.JMModal(showModal: $showPermissionsAlert, for: [.camera, .photo], autoDismiss: true)
        }
    }
}

struct PostCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        PostCategoriesView()
    }
}
