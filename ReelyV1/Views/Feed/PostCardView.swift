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
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                HStack {
                    if let profilePicImageUrl = post.author.profilePicImageUrl {
                        KFImage(URL(string: profilePicImageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 16)
                    }
                    Text(post.author.displayName ?? "Name").font(Font.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "heart").font(Font.system(size: 12)).foregroundColor(.gray)
                }.padding(.horizontal)
                .padding(.bottom, 8)
            }
        }.cornerRadius(10)
    }
}
//
//struct PostCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCardView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
//    }
//}
