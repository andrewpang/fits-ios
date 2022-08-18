//
//  MyPostsFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 7/21/22.
//

import SwiftUI
import WaterfallGrid

struct ProfilePostsFeedView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    @State var showPostDetailView = false
    var profileUserId: String? //Current user's posts, if nil
    
    var body: some View {
        NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "profileFeed"), isActive: $showPostDetailView) {
            EmptyView()
        }
        .isDetailLink(false)
        .onAppear {
            if let profileUserId = profileUserId {
                self.userProfileViewModel.fetchPostsForUser(for: profileUserId)
            } else {
                self.userProfileViewModel.fetchCurrentUserPosts()
            }
        }
        if let postModels = userProfileViewModel.postsData.postModels, !postModels.isEmpty {
            WaterfallCollectionViewController(postsModel: $userProfileViewModel.postsData, uiCollectionViewController: UICollectionViewController())
        } else {
            Text("You don't have any posts yet :(")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .padding(.vertical, 24)
        }
    }
}
