//
//  FollowingRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI
import Kingfisher

struct FollowerFollowingRowView: View {

    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var followerFollowingViewModel = FollowerFollowingViewModel()
    @State var userId: String
    @State var showUnfollowConfirmationDialog = false
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            HStack {
                if let profilePicImageUrl = followerFollowingViewModel.userModel.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.thumbnailWidth)))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .clipShape(Circle())
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .clipShape(Circle())
                }
                Text(followerFollowingViewModel.userModel.displayName ?? "Follower")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 8)
                Spacer()
                if let userId = followerFollowingViewModel.userModel.id {
                    if (authenticationViewModel.isFollowingUser(with: userId)) {
                        HStack {
                           Text("Following")
                                .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                .padding(.horizontal, 4)
                                .fixedSize()
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 8)
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
                                    .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                    .padding(.horizontal, 4)
                                    .fixedSize()
                            } else {
                                Text("Follow")
                                     .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                     .padding(.horizontal, 4)
                                     .fixedSize()
                            }
                        }.padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color(Constants.darkBackgroundColor))
                        .foregroundColor(Color(Constants.backgroundColor))
                        .cornerRadius(10)
                        .onTapGesture {
                            authenticationViewModel.followUser(with: userId)
                            generator.notificationOccurred(.success)
                        }
                    }
                }
            }.padding(.horizontal, 24)
            Divider()
        }.confirmationDialog("Unfollow User", isPresented: $showUnfollowConfirmationDialog) {
            Button ("Unfollow", role: ButtonRole.destructive) {
                if let userId = followerFollowingViewModel.userModel.id {
                    authenticationViewModel.unfollowUser(with: userId)
                }
            }
            Button ("Cancel", role: ButtonRole.cancel) {}
        } message: {
            Text ("Are you sure you want to stop following this user?")
        }.onAppear {
            followerFollowingViewModel.getUserModel(with: userId)
        }.onDisappear {
            followerFollowingViewModel.removeListeners()
        }
    }
}

//struct FollowingRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingRowView()
//    }
//}
