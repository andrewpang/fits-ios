//
//  PostDetailView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/28/22.
//

import SwiftUI
import Kingfisher
import Amplitude

struct PostDetailView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var source = "homeFeed"
    
    let generator = UINotificationFeedbackGenerator()
    
    enum PostDetailFocusField: Hashable {
       case commentField
    }
   
    @FocusState var focusedField: PostDetailFocusField?

    func postCommentAndDismissKeyboard() {
        let commentModel = CommentModel(author: authenticationViewModel.getPostAuthorMap(), commentText: postDetailViewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines))
        postDetailViewModel.postComment(commentModel: commentModel)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if let imageUrls = postDetailViewModel.postModel.imageUrls, !imageUrls.isEmpty {
                            if (imageUrls.count > 1) {
                                TabView() {
                                    ForEach(imageUrls, id: \.self) { imageUrl in
                                        KFImage(URL(string: imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .padding(.vertical)
                                    }
                                }.frame(height: geometry.size.width)
                                .tabViewStyle(PageTabViewStyle())
                            } else {
                                KFImage(URL(string: postDetailViewModel.postModel.imageUrls?[0] ?? ""))
                                    .resizable()
                                    .scaledToFill()
                            }
                        } else {
                            //TODO: Clean this up after everyone is ported over to imageUrls array
                            KFImage(URL(string: postDetailViewModel.postModel.imageUrl ?? ""))
                                .resizable()
                                .scaledToFill()
                        }
                       
    //                    HStack {
    //
    //                        Text("Posted by: " + (postDetailViewModel.postModel.author.displayName ?? "Name"))
    //                            .font(Font.custom(Constants.bodyFont, size: 16))
    //                            .foregroundColor(.gray)
    //                        Spacer()
    //                    }.padding(.horizontal, 24)
    //
                        HStack {
                            Spacer()
                            Text(postDetailViewModel.postModel.title)
                                .font(Font.custom(Constants.titleFontBold, size: 20))
                                .multilineTextAlignment(.center)
                            Spacer()
                            
                        }.padding(.top, 16)
                        .padding(.horizontal, 24)
                        
                        Text(postDetailViewModel.postModel.body)
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                        
                        HStack {
    //                        Spacer()
                            if (postDetailViewModel.isLiked) {
                                Button(action: {
                                    generator.notificationOccurred(.error)
                                    postDetailViewModel.unlikePost(userId: authenticationViewModel.userModel?.id)
                                    let propertiesDict = ["isLike": false as Bool] as [String : Any]
                                    Amplitude.instance().logEvent("Like Button - Clicked", withEventProperties: propertiesDict)
                                }, label: {
                                    Image(systemName: "hands.clap.fill")
                                        .font(.system(size: 28.0, weight: .light))
                                        .foregroundColor(.gray)
                                })
                                if (postDetailViewModel.postModel.likesCount ?? 0 > 1) {
                                    Text("Applauded by others + you!")
                                        .font(Font.custom(Constants.bodyFont, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                } else {
                                    Text("Applauded by you!")
                                        .font(Font.custom(Constants.bodyFont, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                }
                            } else {
                                Button(action: {
                                    generator.notificationOccurred(.success)
                                    postDetailViewModel.likePost(likeModel: LikeModel(id: authenticationViewModel.userModel?.id, author: authenticationViewModel.getPostAuthorMap()))
                                    let propertiesDict = ["isLike": true as Bool] as [String : Any]
                                    Amplitude.instance().logEvent("Like Button - Clicked", withEventProperties: propertiesDict)
                                }, label: {
                                    Image(systemName: "hands.clap")
                                        .font(.system(size: 28.0, weight: .light))
                                        .foregroundColor(.gray)
                                })
                                if (postDetailViewModel.postModel.likesCount ?? 0 > 0) {
                                    Text("Applauded by others!")
                                        .font(Font.custom(Constants.bodyFont, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                } else {
                                    Text("Be the first to applaud!")
                                        .font(Font.custom(Constants.bodyFont, size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)
                                }
                            }
                            Spacer()
                        }.padding(.horizontal, 24)
                        
                        Divider()
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                        
                        CommentsView(postDetailViewModel: postDetailViewModel, focusedField: _focusedField)
                            .padding(.horizontal, 24)
                    }
                }.onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                .padding(.bottom, 8)
                Divider()
                HStack {
                    if let profilePicImageUrl = authenticationViewModel.userModel?.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                        KFImage(URL(string: profilePicImageUrl))
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
                            .focused($focusedField, equals: .commentField)
                            .submitLabel(.send)
                            .onSubmit {
                                let propertiesDict = ["commentLength": postDetailViewModel.commentText.count as Any] as [String : Any]
                                Amplitude.instance().logEvent("Submit Comment - Clicked", withEventProperties: propertiesDict)
                                postCommentAndDismissKeyboard()
                            }
                    } else {
                        // Fallback on earlier versions
                        TextField("Add Comment", text: $postDetailViewModel.commentText)
                            .font(Font.custom(Constants.bodyFont, size: 16))
                            .focused($focusedField, equals: .commentField)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 16)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    if (!postDetailViewModel.commentText.isEmpty) {
                        Button(action: {
                            let propertiesDict = ["commentLength": postDetailViewModel.commentText.count as Any] as [String : Any]
                            Amplitude.instance().logEvent("Submit Comment - Clicked", withEventProperties: propertiesDict)
                            postCommentAndDismissKeyboard()
                        }) {
                            Image(systemName: "arrow.up.circle")
                                .font(.system(size: 32.0))
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
            .onAppear {
                let propertiesDict = [
                    "postId": postDetailViewModel.postModel.id as Any,
                    "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
                    "source": self.source,
                ] as [String : Any]
                Amplitude.instance().logEvent("Post Detail Screen - View", withEventProperties: propertiesDict)
                self.postDetailViewModel.fetchComments()
                self.postDetailViewModel.fetchLikes(userId: authenticationViewModel.userModel?.id)
            }
            .onDisappear {
                self.postDetailViewModel.removeListeners()
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if let profilePicImageUrl = postDetailViewModel.postModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                        KFImage(URL(string: profilePicImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constants.postAuthorProfilePicSize, height:  Constants.postAuthorProfilePicSize)
                            .clipShape(Circle())
                    } else {
                        Image("portraitPlaceHolder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constants.postAuthorProfilePicSize, height:  Constants.postAuthorProfilePicSize)
                            .clipShape(Circle())
                    }
                    
                    Text(postDetailViewModel.postModel.author.displayName ?? "Name")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                }
            }
        }
    }
}
