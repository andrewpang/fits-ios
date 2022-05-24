//
//  HomeView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var posts: [Post] = []
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            StaggeredGrid(columns: 2, list: homeViewModel.postsData.postModels ?? [], content: { post in
//                PostCardView(post: post)
                Text(post.title)
            })
            .padding(.horizontal)
            .navigationTitle("Home")
        }
        .onAppear{
//            for index in 1...10 {
//                posts.append(Post(imageUrl: "post\(index)"))
//            }
            self.homeViewModel.fetchPosts()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct PostCardView: View {
    
    var post: Post
    
    var body: some View {
        Image(post.imageUrl)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
