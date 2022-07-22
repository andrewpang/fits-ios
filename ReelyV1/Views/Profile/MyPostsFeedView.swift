//
//  MyPostsFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 7/21/22.
//

import SwiftUI
import WaterfallGrid

struct MyPostsFeedView: View {
    @StateObject var myProfileViewModel: MyProfileViewModel = MyProfileViewModel()
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    @State var showPostDetailView = false
    
    var body: some View {
        NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel), isActive: $showPostDetailView) {
            EmptyView()
        }
        .isDetailLink(false)
        .onAppear {
            self.myProfileViewModel.fetchPosts()
        }
        if let postModels = myProfileViewModel.postsData.postModels, !postModels.isEmpty {
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
        } else {
            Text("You don't have any posts yet :(")
                .font(Font.custom(Constants.bodyFont, size: 16))
                .padding(.vertical, 24)
        }
    }
}

struct MyPostsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyPostsFeedView()
    }
}
