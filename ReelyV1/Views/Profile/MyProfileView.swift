//
//  MyProfileView.swift
//  FITs
//
//  Created by Andrew Pang on 7/7/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel

struct MyProfileView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var userProfileViewModel = UserProfileViewModel()
    @State var showUploadPicConfirmationDialog = false
    @State var showSignOutConfirmationDialog = false
    @State var showPicker = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isEditMode = false
    @State var selectedImage: UIImage? = nil
    
    init() {
//        let coloredAppearance = UINavigationBarAppearance()
//        coloredAppearance.configureWithOpaqueBackground()
//        coloredAppearance.backgroundColor = UIColor(named: Constants.backgroundColor)
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().compactAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//        UINavigationBar.appearance().tintColor = UIColor(named: Constants.backgroundColor)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Text(self.authenticationViewModel.userModel?.displayName ?? "Name")
                    .font(Font.custom(Constants.titleFontBold, size: 40)).padding(.top, 4)
                MyProfilePictureView(authenticationViewModel: authenticationViewModel, showUploadPicConfirmationDialog: $showUploadPicConfirmationDialog)
                HStack(spacing: 8) {
                    Spacer()
                    FollowersButton()
                    FollowingButton()
                    Spacer()
                }.padding(.horizontal, 16)
                .padding(.vertical, 8)
                Divider()
                    .frame(height: 1)
                    .overlay(Color(Constants.darkBackgroundColor))
                    .padding(.vertical, 8)
                MyProfileInfoView(userProfileViewModel: userProfileViewModel, authenticationViewModel: authenticationViewModel)
                Divider()
                    .frame(height: 1)
                    .overlay(Color(Constants.darkBackgroundColor))
                    .padding(.vertical, 8)
                
//                FeedbackButton()
//                    .padding(.vertical, 8)
                ProfileCategoryTabBarView(currentTab: self.$userProfileViewModel.currentTab)
//                TabView(selection: self.$userProfileViewModel.currentTab) {
//                    ProfilePostsFeedView(userProfileViewModel: userProfileViewModel).tag(0)
//                    CollectionsProfileFeedView(userProfileViewModel: userProfileViewModel).tag(1)
//                }.tabViewStyle(.page(indexDisplayMode: .never))
                if (userProfileViewModel.currentTab == 0) {
                    ProfilePostsFeedView(userProfileViewModel: userProfileViewModel).onAppear {
                        let eventName = "Profile Post Tab - View"
                        let propertiesDict = ["isUsersOwnProfile": true] as? [String : String]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                    }
                } else {
                    CollectionsProfileView(userProfileViewModel: userProfileViewModel).onAppear {
                        let eventName = "Profile Collections Tab - View"
                        let propertiesDict = ["isUsersOwnProfile": true] as? [String : String]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                    }
                }
                
            }.sheet(isPresented: $showPicker) {
                UIImagePicker(selectedImage: $selectedImage, isPresented: $showPicker, sourceType: sourceType)
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
                    .foregroundColor(Color.gray)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                       Text("Edit Profile")
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .padding(.horizontal, 4)
                            .fixedSize()
                    }.padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background(Color(Constants.darkBackgroundColor))
                    .foregroundColor(Color(Constants.backgroundColor))
                    .cornerRadius(10)
                    .onTapGesture {
                        self.isEditMode = true
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .background(Color(Constants.backgroundColor))
        .onAppear {
            let eventName = "My Profile Screen - View"
            Amplitude.instance().logEvent(eventName)
            Mixpanel.mainInstance().track(event: eventName)
            userProfileViewModel.userModel = authenticationViewModel.userModel
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

struct MyProfilePictureView: View {
    
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Binding var showUploadPicConfirmationDialog: Bool
    
    var body: some View {
        HStack {
            Spacer()
            if let profilePicImageUrl = authenticationViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.thumbnailWidth)))
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
                .foregroundColor(Color.gray)
        }).padding(.bottom, 8)
    }
}

struct MyProfileInfoView: View {
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
//            Text(self.authenticationViewModel.userModel?.school ?? "Fashion Institute of Technology")
//                .font(Font.custom(Constants.bodyFont, size: 16))
        Group {
            if ((self.authenticationViewModel.userModel?.major ?? "").isEmpty) {
                Text("No Major Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text((self.authenticationViewModel.userModel?.major)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
            
            if (self.authenticationViewModel.userModel?.graduationYear ?? -1 == -1) {
                Text("No Graduation Year Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text(String((self.authenticationViewModel.userModel?.graduationYear)!))
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
            
            if ((self.authenticationViewModel.userModel?.bio ?? "").isEmpty) {
                Text("No Bio Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text((self.authenticationViewModel.userModel?.bio)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
            Text("Post Streak: \(userProfileViewModel.postStreak) 🪄")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .multilineTextAlignment(.center)
        }.padding(.vertical, 4)
        .padding(.horizontal, 24)
    }
}

struct FeedbackButton: View {
    
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            openMail()
        }) {
            HStack {
                Text("Feedback for FIT(s)")
                    .font(Font.custom(Constants.buttonFont, size: Constants.buttonFontSize))
                    .foregroundColor(Color(Constants.backgroundColor))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 55)
            .background(Color(Constants.darkBackgroundColor))
            .cornerRadius(Constants.buttonCornerRadius)
            .padding(.horizontal, 40)
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Email app not supported"), message: Text("Please email any feedback to feedback@fitsatfit.com"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func openMail() {
        let email = "feedback@fitsatfit.com"
        let subject = "Feedback%20for%20FIT(s)"
        let body = "How%20can%20we%20make%20the%20FIT(s)%20app%20better%20for%20you%3F%20Send%20us%20an%20email%20with%20comments,%20questions,%20or%20feedback!"
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showingAlert = true
            }
        } else {
            self.showingAlert = true
        }
    }
}

struct FollowersButton: View {
    
    var body: some View {
        NavigationLink(destination: FollowerFollowingParentView(selectedTab: FollowerFollowingParentView.followersTabIndex)) {
            HStack {
               Text("Followers")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 4)
                    .fixedSize()
            }.padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color(Constants.backgroundColor))
            .foregroundColor(Color(Constants.darkBackgroundColor))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(Constants.darkBackgroundColor), lineWidth: 1)
            )
        }.isDetailLink(false)
    }
}

struct FollowingButton: View {
    
    var body: some View {
        NavigationLink(destination: FollowerFollowingParentView(selectedTab: FollowerFollowingParentView.followingTabIndex)) {
            HStack {
               Text("Following")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 4)
                    .fixedSize()
            }.padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color(Constants.backgroundColor))
            .foregroundColor(Color(Constants.darkBackgroundColor))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(Constants.darkBackgroundColor), lineWidth: 1)
            )
        }.isDetailLink(false)
    }
}

struct ProfileCategoryTabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    @State var selectedCategoryTag = "" //Not needed on Profile at the moment
    
    var tabBarOptions: [String] = ["Posts", "Collections"]
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                Spacer()
                ForEach(Array(zip(self.tabBarOptions.indices,
                                      self.tabBarOptions)),
                        id: \.0,
                        content: {
                        index, name in
                            CategoryTabBarItem(currentTab: self.$currentTab,
                                               selectedCategoryTag: self.$selectedCategoryTag,
                                               namespace: namespace.self,
                                               tabBarItemName: name,
                                               tab: index)
                        
                        })
                Spacer()
            }.padding(.horizontal, 8)
//        }
        .frame(height: 40)
    }
}

