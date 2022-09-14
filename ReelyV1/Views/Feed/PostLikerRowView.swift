//
//  PostLikerRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/6/22.
//

import SwiftUI
import Kingfisher

struct PostLikerRowView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var likeModel: LikeModel
    @State var showUnfollowConfirmationDialog = false
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack {
            HStack {
                if let profilePicImageUrl = likeModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
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
                Text(likeModel.author.displayName ?? "Commentor")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 8)
                Spacer()
                if let likerUserId = likeModel.author.userId {
                    if (authenticationViewModel.isFollowingUser(with: likerUserId)) {
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
                            if (authenticationViewModel.isUserFollowingCurrentUser(with: likerUserId)) {
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
                            authenticationViewModel.followUser(with: likerUserId)
                            generator.notificationOccurred(.success)
                        }
                    }
                }
            }.padding(.horizontal, 24)
            Divider()
        }.confirmationDialog("Unfollow User", isPresented: $showUnfollowConfirmationDialog) {
            Button ("Unfollow", role: ButtonRole.destructive) {
                if let likerUserId = likeModel.author.userId {
                    authenticationViewModel.unfollowUser(with: likerUserId)
                }
            }
            Button ("Cancel", role: ButtonRole.cancel) {}
        } message: {
            Text ("Are you sure you want to stop following this user?")
        }
    }
}
