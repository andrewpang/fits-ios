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
                    HStack {
                        Text(post.title).font(Font.system(size: 18)).bold().foregroundColor(.black)
                        Spacer()
                        Image(systemName: "heart").foregroundColor(.black)
                    }
                    Text("Posted by: " + post.author).foregroundColor(.gray)
                    Text(post.body).padding(.top)
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
