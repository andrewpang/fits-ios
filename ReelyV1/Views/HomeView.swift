//
//  HomeView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationView {
            StaggeredGrid(columns: 2, list: posts, content: { post in
                PostCardView(post: post)
            })
            .padding(.horizontal)
            .navigationTitle("Home")
        }
        .onAppear{
            for index in 1...10 {
                posts.append(Post(imageUrl: "post\(index)"))
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
    
    var post: Post
    
    var body: some View {
        Image(post.imageUrl)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
