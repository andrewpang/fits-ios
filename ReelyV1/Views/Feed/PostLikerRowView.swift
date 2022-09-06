//
//  PostLikerRowView.swift
//  FITs
//
//  Created by Andrew Pang on 9/6/22.
//

import SwiftUI
import Kingfisher

struct PostLikerRowView: View {
    @State var likeModel: LikeModel
    
    var body: some View {
        VStack {
            HStack {
                if let profilePicImageUrl = likeModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .clipShape(Circle())
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.likesListProfilePicSize, height:  Constants.likesListProfilePicSize)
                        .clipShape(Circle())
                }
                Text(likeModel.author.displayName ?? "Commentor")
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 8)
                Spacer()
            }.padding(.horizontal, 24)
            Divider()
        }
    }
}
