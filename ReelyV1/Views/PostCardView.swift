//
//  PostCardView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/28/22.
//

import SwiftUI
import Kingfisher

struct PostCardView: View {
    var post: PostModel
    
    var body: some View {
        ZStack {
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

struct PostCardView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
    }
}
