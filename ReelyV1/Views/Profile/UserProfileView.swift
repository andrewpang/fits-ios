//
//  UserProfileView.swift
//  FITs
//
//  Created by Andrew Pang on 7/24/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel
import ConfettiSwiftUI

struct UserProfileView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var userProfileViewModel = UserProfileViewModel()
    var userId: String
    @State var showUnfollowConfirmationDialog = false
    
    let generator = UINotificationFeedbackGenerator()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Text(self.userProfileViewModel.userModel?.displayName ?? "Name")
                    .font(Font.custom(Constants.titleFontBold, size: 40)).padding(.top, 4)

                ProfilePictureView(userProfileViewModel: userProfileViewModel)
                Divider().padding(.vertical, 8)
                ProfileInfoView(userProfileViewModel: userProfileViewModel)
                Divider().padding(.vertical, 8)
                    .padding(.vertical, 8)
                HStack {
                    Text("Posts")
                        .font(Font.custom(Constants.titleFont, size: 24))
                    Spacer()
                    Text("Post Streak: \(userProfileViewModel.postStreak) 🪄")
                        .font(Font.custom(Constants.titleFont, size: 16))
                }.padding(.horizontal, 16)
                .padding(.vertical, 8)
                ProfilePostsFeedView(userProfileViewModel: userProfileViewModel, profileUserId: userId)
            }
        }.onAppear {
            userProfileViewModel.fetchUserModel(for: userId)
            let eventName = "User Profile Screen - View"
            let propertiesDict = [
                "userId": userId as String,
            ] as? [String : String]
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
        }.onDisappear {
            userProfileViewModel.removeListeners()
        }.navigationBarTitle("", displayMode: .inline)
        .background(Color(Constants.backgroundColor))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack {
                    if (authenticationViewModel.isFollowingUser(with: userId)) {
                        HStack {
                           Text("Following")
                                .font(Font.custom(Constants.bodyFont, size: 16))
                                .padding(.horizontal, 4)
                                .fixedSize()
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color(Constants.backgroundColor))
                        .foregroundColor(Color(Constants.darkBackgroundColor))
                        .cornerRadius(10)
                        .onTapGesture {
                            showUnfollowConfirmationDialog = true
                            generator.notificationOccurred(.warning)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(Constants.darkBackgroundColor), lineWidth: 1)
                        )
                    } else {
                        HStack {
                            if (authenticationViewModel.isUserFollowingCurrentUser(with: userId)) {
                               Text("Follow Back")
                                    .font(Font.custom(Constants.bodyFont, size: 16))
                                    .padding(.horizontal, 4)
                                    .fixedSize()
                            } else {
                                Text("Follow")
                                     .font(Font.custom(Constants.bodyFont, size: 16))
                                     .padding(.horizontal, 4)
                                     .fixedSize()
                            }
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color(Constants.darkBackgroundColor))
                        .foregroundColor(Color(Constants.backgroundColor))
                        .cornerRadius(10)
                        .onTapGesture {
                            authenticationViewModel.followUser(with: userId)
                            userProfileViewModel.confettiCounter += 1
                            generator.notificationOccurred(.success)
                        }
                    }
                }
            }
        }.confirmationDialog("Unfollow User", isPresented: $showUnfollowConfirmationDialog) {
            Button ("Unfollow", role: ButtonRole.destructive) {
                authenticationViewModel.unfollowUser(with: userId)
            }
            Button ("Cancel", role: ButtonRole.cancel) {}
        } message: {
            Text ("Are you sure you want to stop following this user?")
        }
    }
}

struct ProfilePictureView: View {
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            if let profilePicImageUrl = userProfileViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.thumbnailWidth)))
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.profilePageProfilePicSize, height:  Constants.profilePageProfilePicSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(Constants.onBoardingButtonColor), lineWidth: 3))
                    .padding()
            } else {
                Image("portraitPlaceHolder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.profilePageProfilePicSize, height:  Constants.profilePageProfilePicSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(Constants.onBoardingButtonColor), lineWidth: 3))
                    .padding()
            }
            Spacer()
        }.confettiCannon(counter: $userProfileViewModel.confettiCounter, num: 50, confettis: [.text("📸"), .text("✨"), .text("👖"), .text("👠"), .text("👟"), .text("👗")], confettiSize: 25, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
    }
}

struct ProfileInfoView: View {
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
//            Text(self.authenticationViewModel.userModel?.school ?? "Fashion Institute of Technology")
//                .font(Font.custom(Constants.bodyFont, size: 16))
        Group {
            if ((self.userProfileViewModel.userModel?.major ?? "").isEmpty) {
                Text("No Major Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text((self.userProfileViewModel.userModel?.major)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
            
            if (self.userProfileViewModel.userModel?.graduationYear ?? -1 == -1) {
                Text("No Graduation Year Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text(String((self.userProfileViewModel.userModel?.graduationYear)!))
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
            
            
            if ((self.userProfileViewModel.userModel?.bio ?? "").isEmpty) {
                Text("No Bio Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            } else {
                Text((self.userProfileViewModel.userModel?.bio)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .multilineTextAlignment(.center)
            }
        }.padding(.vertical, 4)
        .padding(.horizontal, 24)
    }
}
