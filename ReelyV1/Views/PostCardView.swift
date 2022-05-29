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
                Text(post.title)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                HStack {
                    Text(post.author).font(Font.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "heart").foregroundColor(.black)
                }.padding(.horizontal)
                .padding(.bottom)
            }
        }.cornerRadius(10)
    }
}

struct PostCardView_Previews: PreviewProvider {
    static var previews: some View {
        PostCardView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
    }
}
