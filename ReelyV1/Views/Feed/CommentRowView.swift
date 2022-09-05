//
//  CommentRowView.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel

struct CommentRowView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @State var commentModel: CommentModel
    
    let generator = UINotificationFeedbackGenerator()
    
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
            if let commentId = commentModel.id {
                if let commentLikesModel = postDetailViewModel.commentIdToCommentLikesDictionary[commentId], commentLikesModel.hasUserHasLikedComment(with: authenticationViewModel.userModel?.id ?? "noId") {
                    Button(action: {
                        generator.notificationOccurred(.error)
                        postDetailViewModel.unlikeComment(commentId: commentId, userId: authenticationViewModel.userModel?.id)
                        let eventName = "Comment Like Button - Clicked"
                        let propertiesDict = ["isLike": false as Bool, "postId": postDetailViewModel.postModel.id ?? "noId", "commentId": commentId] as? [String : Any]
                        let mixpanelDict = ["isLike": false as Bool, "postId": postDetailViewModel.postModel.id ?? "noId", "commentId": commentId] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }, label: {
                        Image(systemName: "hands.clap.fill")
                            .font(.system(size: 16.0, weight: .light))
                            .foregroundColor(Color("FITColor"))
                    })
                } else {
                    Button(action: {
                        generator.notificationOccurred(.success)
                        postDetailViewModel.likeComment(commentLikeModel: CommentLikeModel(id: authenticationViewModel.userModel?.id, commentId: commentId, author: authenticationViewModel.getPostAuthorMap()))
                        let eventName = "Comment Like Button - Clicked"
                        let propertiesDict = ["isLike": true as Bool, "postId": postDetailViewModel.postModel.id ?? "noId", "commentId": commentId] as? [String : Any]
                        let mixpanelDict = ["isLike": true as Bool, "postId": postDetailViewModel.postModel.id ?? "noId", "commentId": commentId] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }, label: {
                        Image(systemName: "hands.clap")
                            .font(.system(size: 16.0, weight: .light))
                            .foregroundColor(.gray)
                    })
                }
            }
        }
    }
}

//struct CommentRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentRowView(commentModel: CommentModel(author: PostAuthorMap(displayName: "Name", profilePicImageUrl: nil, userId: nil), commentText: "This is a comment"))
//    }
//}
