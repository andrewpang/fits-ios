//
//  CommentRowView.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import SwiftUI
import Kingfisher

struct CommentRowView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var commentModel: CommentModel
    
    var body: some View {
        HStack(alignment: .top) {
            NavigationLink(destination: UserProfileView(userId: commentModel.author.userId!)) {
                if let profilePicImageUrl = commentModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.commentsProfilePicSize, height:  Constants.commentsProfilePicSize)
                        .clipShape(Circle())
                } else {
                    Image("portraitPlaceHolder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.commentsProfilePicSize, height:  Constants.commentsProfilePicSize)
                        .clipShape(Circle())
                }
            }.disabled(commentModel.author.userId?.isEmpty ?? true)
            
            VStack(alignment: .leading) {
                NavigationLink(destination: UserProfileView(userId: commentModel.author.userId!)) {
                    Text(commentModel.author.displayName ?? "Commentor")
                        .font(Font.system(size: 16, weight: .bold, design: .default))
                }.disabled(commentModel.author.userId?.isEmpty ?? true)
                Text(commentModel.commentText)
                    .font(Font.custom(Constants.bodyFont, size: 16))
            }
            Spacer()
        }
    }
}

struct CommentRowView_Previews: PreviewProvider {
    static var previews: some View {
        CommentRowView(commentModel: CommentModel(author: PostAuthorMap(displayName: "Name", profilePicImageUrl: nil, userId: nil), commentText: "This is a comment"))
    }
}
