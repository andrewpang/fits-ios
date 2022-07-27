//
//  UserProfileView.swift
//  FITs
//
//  Created by Andrew Pang on 7/24/22.
//

import SwiftUI
import Kingfisher
import Amplitude

struct UserProfileView: View {
    @StateObject var userProfileViewModel = UserProfileViewModel()
    var userId: String

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
                }.padding(.horizontal, 16)
                .padding(.vertical, 8)
                ProfilePostsFeedView(userProfileViewModel: userProfileViewModel, profileUserId: userId)
            }
        }.onAppear {
            userProfileViewModel.fetchUserModel(for: userId)
            let propertiesDict = [
                "userId": userId as Any,
            ] as [String : Any]
            Amplitude.instance().logEvent("User Profile Screen - View", withEventProperties: propertiesDict)
        }.onDisappear {
            userProfileViewModel.removeListeners()
        }.navigationBarTitle("", displayMode: .inline)
        .background(Color(Constants.backgroundColor))
    }
}

struct ProfilePictureView: View {
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        HStack {
            Spacer()
            if let profilePicImageUrl = userProfileViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                KFImage(URL(string: profilePicImageUrl))
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
        }
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
            } else {
                Text((self.userProfileViewModel.userModel?.major)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
            }
            
            if (self.userProfileViewModel.userModel?.graduationYear ?? -1 == -1) {
                Text("No Graduation Year Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
            } else {
                Text(String((self.userProfileViewModel.userModel?.graduationYear)!))
                    .font(Font.custom(Constants.bodyFont, size: 16))
            }
            
            if ((self.userProfileViewModel.userModel?.bio ?? "").isEmpty) {
                Text("No Bio Set")
                    .font(Font.custom(Constants.bodyFont, size: 16))
            } else {
                Text((self.userProfileViewModel.userModel?.bio)!)
                    .font(Font.custom(Constants.bodyFont, size: 16))
            }
        }.padding(.vertical, 4)
        .padding(.horizontal, 24)
    }
}
