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
    @State var isShowingLoadingIndicator = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                if let imageUrls = post.imageUrls, !imageUrls.isEmpty {
                    ZStack(alignment: .topTrailing) {
                        KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrls[0], width: CloudinaryHelper.thumbnailWidth)))
                            .onSuccess {_ in
                                isShowingLoadingIndicator = false
                            }
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
                        .onSuccess {_ in
                            isShowingLoadingIndicator = false
                        }
                        .resizable()
                        .scaledToFit()
                }
                if (isShowingLoadingIndicator) {
                    ProgressView()
                }
            }
            
            HStack {
                Spacer()
                Text(post.title)
                    .font(Font.custom(Constants.titleFontBold, size: Constants.postCardTitleFontSize))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Spacer()
            }.padding(.vertical, Constants.postCardTitleVerticalPadding)
            .padding(.horizontal, Constants.postCardTitleHorizontalPadding)
            .frame(height: Constants.postCardAuthorSectionHeight * 2)
            .background(.red)
            .overlay(
                GeometryReader { proxy in
                    Text("\(proxy.size.width, specifier: "%.2f") x \(proxy.size.height, specifier: "%.2f")")
                }
            )
            HStack {
                if let profilePicImageUrl = post.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
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
            .frame(height: Constants.postCardAuthorSectionHeight)
            .background(.blue)
            .overlay(
                GeometryReader { proxy in
                    Text("\(proxy.size.width, specifier: "%.2f") x \(proxy.size.height, specifier: "%.2f")")
                }
            )
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
