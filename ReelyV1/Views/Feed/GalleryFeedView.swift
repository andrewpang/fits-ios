//
//  GalleryFeedView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import PermissionsSwiftUINotification

struct GalleryFeedView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @State var showNotificationPermissionModal = true
    
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
                .JMAlert(showModal: $showNotificationPermissionModal, for: [.notification], restrictDismissal: false, autoDismiss: true)
        }
        .onAppear {
            self.homeViewModel.fetchPosts()
        }
    }
}
