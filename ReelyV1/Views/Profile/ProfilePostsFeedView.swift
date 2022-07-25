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
        //TODO: Remove this home view model
        NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, homeViewModel: HomeViewModel(), source: "myPostsFeed"), isActive: $showPostDetailView) {
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
            //HACK: WaterfallGrid doesn't show any resizable images when there's not enough grid height
            if (postModels.count == 1) {
                HStack {
                    Button(action: {
                        postDetailViewModel = PostDetailViewModel(postModel: postModels[0])
                        showPostDetailView = true
                    }, label: {
                        PostCardView(post: postModels[0])
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 4))
                    })
                    PostCardView(post: postModels[0])
                        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 8)).hidden()
                }
            } else if (postModels.count == 2) {
                HStack {
                    Button(action: {
                        postDetailViewModel = PostDetailViewModel(postModel: postModels[0])
                        showPostDetailView = true
                    }, label: {
                        PostCardView(post: postModels[0])
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 2))
                    })
                    Button(action: {
                        postDetailViewModel = PostDetailViewModel(postModel: postModels[1])
                        showPostDetailView = true
                    }, label: {
                        PostCardView(post: postModels[1])
                            .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 8))
                    })
                }
            } else {
                WaterfallGrid(postModels) { post in
                    Button(action: {
                        postDetailViewModel = PostDetailViewModel(postModel: post)
                        showPostDetailView = true
                    }, label: {
                        PostCardView(post: post)
                    })
                }
                .gridStyle(
                    columnsInPortrait: 2,
                    columnsInLandscape: 3,
                    spacing: 8,
                    animation: .none
                )
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
        } else {
            Text("You don't have any posts yet :(")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .padding(.vertical, 24)
        }
    }
}
