//
//  MyProfileView.swift
//  FITs
//
//  Created by Andrew Pang on 7/7/22.
//

import SwiftUI
import Kingfisher
import Amplitude

struct MyProfileView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showUploadPicConfirmationDialog = false
    @State var showSignOutConfirmationDialog = false
    @State var showPicker = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isEditMode = false
    @State var selectedImage: UIImage? = nil
    
    @State private var mailData = ComposeMailData(subject: "Feedback for FIT(s)",
                                                    recipients: ["feedback@fitsatfit.com"],
                                                    message: "Email us feedback, questions, comments and we'll get back to you soon!",
                                                    attachments: nil)
    @State private var showMailView = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(self.authenticationViewModel.userModel?.displayName ?? "Name")
                .font(Font.custom(Constants.titleFontBold, size: 40))
            HStack {
                Spacer()
                if let profilePicImageUrl = authenticationViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: profilePicImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.profilePageProfilePicSize, height:  Constants.profilePageProfilePicSize)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(Constants.onBoardingButtonColor), lineWidth: 3))
                        .padding()
                        .onTapGesture {
                            self.showUploadPicConfirmationDialog = true
                        }
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.profilePageProfilePicSize, height:  Constants.profilePageProfilePicSize)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(Constants.onBoardingButtonColor), lineWidth: 3))
                        .padding()
                        .onTapGesture {
                            self.showUploadPicConfirmationDialog = true
                        }
                }
                Spacer()
            }
            Button(action: {
                self.showUploadPicConfirmationDialog = true
            }, label: {
                Text("Update Profile Photo")
                    .font(Font.custom(Constants.buttonFont, size: 16))
            }).padding(.bottom, 16)
            
            Divider().padding(.vertical, 8)
           
//            Text(self.authenticationViewModel.userModel?.school ?? "Fashion Institute of Technology")
//                .font(Font.custom(Constants.bodyFont, size: 16))
            Group {
                if ((self.authenticationViewModel.userModel?.major ?? "").isEmpty) {
                    Text("No Major Set")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                } else {
                    Text((self.authenticationViewModel.userModel?.major)!)
                        .font(Font.custom(Constants.bodyFont, size: 16))
                }
                
                if (self.authenticationViewModel.userModel?.graduationYear ?? -1 == -1) {
                    Text("No Graduation Year Set")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                } else {
                    Text(String((self.authenticationViewModel.userModel?.graduationYear)!))
                        .font(Font.custom(Constants.bodyFont, size: 16))
                }
                
                if ((self.authenticationViewModel.userModel?.bio ?? "").isEmpty) {
                    Text("No Bio Set")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                } else {
                    Text((self.authenticationViewModel.userModel?.bio)!)
                        .font(Font.custom(Constants.bodyFont, size: 16))
                }
            }.padding(.vertical, 4)
            
            Divider().padding(.vertical, 8)
            
            Spacer()
            
            Button(action: {
                showMailView.toggle()
            }) {
                HStack {
                    Text("Contact/Give Feedback")
                        .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                        .foregroundColor(Color(Constants.backgroundColor))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                .background(Color(Constants.darkBackgroundColor))
                .cornerRadius(Constants.buttonCornerRadius)
                .padding(.horizontal, 40)
                .padding(.bottom, 24)
            }
            .disabled(!MailView.canSendMail)
            .sheet(isPresented: $showMailView) {
                MailView(data: $mailData) { result in
                    print(result)
                }
            }
            }.sheet(isPresented: $showPicker) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showPicker, sourceType: sourceType)
            }.onChange(of: selectedImage) { _ in
                if let image = selectedImage {
                    authenticationViewModel.updateUserProfilePhoto(image: image)
                }
            }
            .confirmationDialog("Sign Out", isPresented: $showSignOutConfirmationDialog) {
                Button ("Sign Out") {
                    authenticationViewModel.signOut()
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
                Text ("Are you sure you want to sign out?")
            }.confirmationDialog("Select a profile photo", isPresented: $showUploadPicConfirmationDialog) {
                Button ("Photo Library") {
                    self.showPicker = true
                    self.sourceType = .photoLibrary
                }
                Button ("Camera") {
                    self.showPicker = true
                    self.sourceType = .camera
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
                Text ("Choose a picture from your photo library, or take one now!")
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        self.showSignOutConfirmationDialog = true
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                       Text("Edit Profile")
                            .font(Font.custom(Constants.bodyFont, size: 16))
                    }.padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .onTapGesture {
                        self.isEditMode = true
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
            .padding(.horizontal, 24)
            .onAppear {
                Amplitude.instance().logEvent("My Profile Screen - View")
            }.sheet(isPresented: $isEditMode, content: {
                EditProfileView()
            })
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
