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
        VStack(alignment: .leading, spacing: 0) {
            if let imageUrls = post.imageUrls, !imageUrls.isEmpty {
                ZStack(alignment: .topTrailing) {
                    KFImage(URL(string: imageUrls[0]))
                        .resizable()
                        .scaledToFit()
                    if (imageUrls.count > 1) {
                        Image(systemName: "square.fill.on.square.fill")
                            .font(.system(size: 14.0, weight: .regular))
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
            } else {
                //TODO: Clean this up after everyone is ported over to imageUrls array
                KFImage(URL(string: post.imageUrl ?? ""))
                    .resizable()
                    .scaledToFit()
            }
            
            HStack {
                Spacer()
                Text(post.title)
                    .font(Font.custom(Constants.titleFontBold, size: 16))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Spacer()
            }.padding(.vertical, 6)
            .padding(.horizontal, 4)
            HStack {
                if let profilePicImageUrl = post.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: profilePicImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.postCardProfilePicSize, height:  Constants.postCardProfilePicSize)
                        .clipShape(Circle())
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.postCardProfilePicSize, height:  Constants.postCardProfilePicSize)
                        .clipShape(Circle())
                }
                Text(post.author.displayName ?? "Name")
                    .font(Font.custom(Constants.bodyFont, size: 12))
                    .foregroundColor(.gray)
                Spacer()
//                    Image(systemName: "heart").font(Font.system(size: 12)).foregroundColor(.gray)
            }.padding(.horizontal)
            .padding(.bottom, 8)
        }.background(Color.white)
        .cornerRadius(Constants.buttonCornerRadius)
    }
}
//
//struct PostCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCardView(post: PostModel(author: "Author", body: "Body Text", imageUrl: "", title: "Title", likes: 0))
//    }
//}
