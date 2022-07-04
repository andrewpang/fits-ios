//
//  GalleryFeedView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct GalleryFeedView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.15).ignoresSafeArea()
                StaggeredGrid(columns: 2, list: homeViewModel.postsData.postModels ?? [], content: { post in
                    NavigationLink(destination: PostDetailView(post: post),
                                       label: {
                            PostCardView(post: post)
                        })
                }).padding(.horizontal)
            }.navigationTitle("Home")
        }
        .onAppear {
            self.homeViewModel.fetchPosts()
        }
    }
}
