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
            ZStack {
                Color.gray.opacity(0.15).ignoresSafeArea()
                StaggeredGrid(columns: 2, list: homeViewModel.postsData.postModels ?? [], content: { post in
                    PostCardView(post: post)
                        
                })
                .padding(.horizontal)
                .navigationTitle("Home")
            }
            .onAppear {
                self.homeViewModel.fetchPosts()
            }
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
        ZStack{
            Color.white
            VStack(alignment: .leading) {
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(post.title).foregroundColor(.black).padding(.horizontal)
                HStack {
                    Text(post.author).font(Font.system(size: 12)).foregroundColor(.black)
                    Image(systemName: "heart").foregroundColor(.black)
                }.padding(.horizontal)
                .padding(.vertical, 8)
            }
        }.cornerRadius(10)
    }
}
