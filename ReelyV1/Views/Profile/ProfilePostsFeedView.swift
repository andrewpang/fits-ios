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
            WaterfallGrid(postModels) { post in
                Button(action: {
                    postDetailViewModel = PostDetailViewModel(postModel: post)
                    showPostDetailView = true
                }, label: {
                    PostCardView(post: post)
                        .fixedSize(horizontal: false, vertical: true) //HACK Fix: https://github.com/paololeonardi/WaterfallGrid/issues/53
                })
            }
            .gridStyle(
                columnsInPortrait: 2,
                columnsInLandscape: 3,
                spacing: 8,
                animation: .none
            )
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        } else {
            Text("You don't have any posts yet :(")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .padding(.vertical, 24)
        }
    }
}
