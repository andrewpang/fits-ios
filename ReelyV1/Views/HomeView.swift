//
//  HomeView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @State var posts: [Post] = []
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            StaggeredGrid(columns: 2, list: homeViewModel.postsData.postModels ?? [], content: { post in
                PostCardView(post: post)
            })
            .padding(.horizontal)
            .navigationTitle("Home")
            .foregroundColor(.gray)
        }
        .onAppear {
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
    
    var post: PostModel
    
    var body: some View {
        VStack {
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(post.title)
            HStack {
                Text(post.author).font(Font.system(size: 12))
                Image(systemName: "heart")
            }
        }.foregroundColor(.white)
        .cornerRadius(10)
    }
}
