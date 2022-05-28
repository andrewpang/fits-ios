//
//  PostDetailView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/28/22.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    var post: PostModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                VStack(alignment: .leading) {
                    Text(post.title).bold()
                    Text(post.body)
                    Text("Posted by: " + post.author)
                }.padding()
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
    }
}
