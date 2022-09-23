//
//  CommentBarView.swift
//  FITs
//
//  Created by Andrew Pang on 9/20/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel
import PopupView

struct CommentBarView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @FocusState var focusedField: PostDetailView.PostDetailFocusField?
    @State var isAnimatingApplaud = false
    @State var isAnimatingBookmark = false
    @State var isCommentFocused = false
    @State var isShowingPopup = false
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        HStack(spacing: 0) {
            if let profilePicImageUrl = authenticationViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.commentsProfilePicSize, height:  Constants.commentsProfilePicSize)
                    .clipShape(Circle())
                    .padding(.leading, 8)
            } else {
                Image("portraitPlaceHolder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: Constants.commentsProfilePicSize, height:  Constants.commentsProfilePicSize)
                    .clipShape(Circle())
                    .padding(.leading, 8)
            }
            if #available(iOS 15.0, *) {
                TextField("Add Comment", text: $postDetailViewModel.commentText)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: PostDetailView.PostDetailFocusField.commentField)
                    .submitLabel(.send)
                    .onSubmit {
                        let eventName = "Submit Comment - Clicked"
                        let propertiesDict = ["commentText": postDetailViewModel.commentText, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : Any]
                        let mixpanelDict = ["commentText": postDetailViewModel.commentText, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                        postCommentAndDismissKeyboard()
                    }
            } else {
                // Fallback on earlier versions
                TextField("Add Comment", text: $postDetailViewModel.commentText)
                    .font(Font.custom(Constants.bodyFont, size: 16))
                    .focused($focusedField, equals: PostDetailView.PostDetailFocusField.commentField)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 16)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            if (!postDetailViewModel.commentText.isEmpty) {
                Button(action: {
                    let eventName = "Submit Comment - Clicked"
                    let propertiesDict = ["commentText": postDetailViewModel.commentText, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : Any]
                    let mixpanelDict = ["commentText": postDetailViewModel.commentText, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : MixpanelType]
                    Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                    Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    postCommentAndDismissKeyboard()
                }) {
                    Image(systemName: "arrow.up.circle")
                        .font(.system(size: 24.0, weight: .light))
                        .foregroundColor(.gray)
                }
            } else if (!isCommentFocused) {
//                if (postDetailViewModel.isLiked) {
//                    Button(action: {
//                        generator.notificationOccurred(.error)
//                        postDetailViewModel.unlikePost(userId: authenticationViewModel.userModel?.id)
//                        let eventName = "Like Button - Clicked"
//                        let propertiesDict = ["isLike": false as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : Any]
//                        let mixpanelDict = ["isLike": false as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : MixpanelType]
//                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
//                    }) {
//                        Image(systemName: "hands.clap.fill")
//                            .font(.system(size: 24.0, weight: .light))
//                            .foregroundColor(Color("FITColor"))
//                            .padding(.horizontal, 8)
//                            .scaleEffect(isAnimatingApplaud ? 1.25 : 1.0)
//                            .animation(.easeInOut(duration: isAnimatingApplaud ? 0.25 : 1.0), value: isAnimatingApplaud)
//                    }
//                } else {
//                    Button(action: {
//                        animateApplaud()
//                        generator.notificationOccurred(.success)
//                        likePostFirebaseAndAnalytics()
//                    }) {
//                        Image(systemName: "hands.clap")
//                            .font(.system(size: 24.0, weight: .light))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal, 8)
//                            .scaleEffect(isAnimatingApplaud ? 1.25 : 1.0)
//                            .animation(.easeInOut(duration: isAnimatingApplaud ? 0.25 : 1.0), value: isAnimatingApplaud)
//                    }
//                }
//                if (postDetailViewModel.isBookmarked) {
//                    Button(action: {
//                        generator.notificationOccurred(.success)
//                        postDetailViewModel.isShowingBoardsSheet = true
//                    }) {
//                        Image(systemName: "bookmark.fill")
//                            .font(.system(size: 24.0, weight: .light))
//                            .foregroundColor(.yellow)
//                            .padding(.horizontal, 8)
//                            .scaleEffect(isAnimatingBookmark ? 1.25 : 1.0)
//                            .animation(.easeInOut(duration: isAnimatingBookmark ? 0.25 : 1.0), value: isAnimatingBookmark)
//                    }
//                } else {
//                    Button(action: {
//                        animateBookmark()
//                        generator.notificationOccurred(.success)
//                        postDetailViewModel.isShowingBookmarkPopup = true
//                        let bookmarkModel = BookmarkModel(bookmarkerId: authenticationViewModel.userModel?.id, postId: postDetailViewModel.postModel.id)
//                        postDetailViewModel.bookmarkPost(bookmarkModel: bookmarkModel)
//                    }) {
//                        Image(systemName: "bookmark")
//                            .font(.system(size: 24.0, weight: .light))
//                            .foregroundColor(.gray)
//                            .padding(.horizontal, 8)
//                            .scaleEffect(isAnimatingBookmark ? 1.25 : 1.0)
//                            .animation(.easeInOut(duration: isAnimatingBookmark ? 0.25 : 1.0), value: isAnimatingBookmark)
//                    }
//                }
            }
        }.padding(.horizontal, 8)
        .sheet(isPresented: $postDetailViewModel.isShowingBoardsSheet) {
            AddToBoardView(postDetailViewModel: postDetailViewModel)
        }
    }
    
    func animateApplaud() {
        isAnimatingApplaud = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.isAnimatingApplaud = false
        })
    }
    
    func animateBookmark() {
        isAnimatingBookmark = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.isAnimatingBookmark = false
        })
    }
    
    func likePostFirebaseAndAnalytics() {
        postDetailViewModel.likePost(likeModel: LikeModel(id: authenticationViewModel.userModel?.id, author: authenticationViewModel.getPostAuthorMap()))
        let eventName = "Like Button - Clicked"
        let propertiesDict = ["isLike": true as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : Any]
        let mixpanelDict = ["isLike": true as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : MixpanelType]
        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
    }
    
    func postCommentAndDismissKeyboard() {
        let commentModel = CommentModel(author: authenticationViewModel.getPostAuthorMap(), commentText: postDetailViewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines))
        postDetailViewModel.postComment(commentModel: commentModel)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
