//
//  CollectionFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import SwiftUI

struct CollectionFeedView: View {
    
    @ObservedObject var bookmarkBoardViewModel: BookmarkBoardViewModel
    
    var body: some View {
        ZStack {
//            NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "homeFeed"), isActive: $homeViewModel.shouldPopToRootViewIfFalse) {
//                EmptyView()
//            }
//            .isDetailLink(false)
            Color(Constants.backgroundColor).ignoresSafeArea()
            VStack(spacing: 0) {
                if let postModels = bookmarkBoardViewModel.postsData.postModels {
                    ForEach(postModels, id: \.id) { postModel in
                        Button(action: {
                            
                        }, label: {
                            Text(postModel.title)
                        })
                    }
                }
            }
        }.onAppear {
            self.bookmarkBoardViewModel.fetchPostsForBookmarkBoard()
        }
    }
}

