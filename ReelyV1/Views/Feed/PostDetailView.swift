//
//  PostDetailView.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/28/22.
//

import SwiftUI
import Kingfisher
import Amplitude
import Mixpanel

struct PostDetailView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showConfirmationDialog = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var source = "homeFeed"
    
    let generator = UINotificationFeedbackGenerator()
    
    enum PostDetailFocusField: Hashable {
       case commentField
    }
   
    @FocusState var focusedField: PostDetailFocusField?
    @State var isShowingLoadingIndicator = true

    func postCommentAndDismissKeyboard() {
        let commentModel = CommentModel(author: authenticationViewModel.getPostAuthorMap(), commentText: postDetailViewModel.commentText.trimmingCharacters(in: .whitespacesAndNewlines))
        postDetailViewModel.postComment(commentModel: commentModel)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func isUsersOwnPost() -> Bool {
        return (postDetailViewModel.postModel.author.userId == authenticationViewModel.userModel?.id) as Bool
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .center) {
                            if let imageUrls = postDetailViewModel.postModel.imageUrls, !imageUrls.isEmpty {
                                if (imageUrls.count > 1) {
                                    TabView() {
                                        ForEach(imageUrls, id: \.self) { imageUrl in
                                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.detailWidth)))
                                                .onProgress {_, _ in
                                                    isShowingLoadingIndicator = true
                                                }
                                                .onSuccess {_ in
                                                    isShowingLoadingIndicator = false
                                                }
                                                .resizable()
                                                .scaledToFill()
                                                .padding(.vertical)
                                        }
                                    }.frame(height: geometry.size.width)
                                    .tabViewStyle(PageTabViewStyle())
                                } else {
                                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: postDetailViewModel.postModel.imageUrls?[0] ?? "", width: CloudinaryHelper.detailWidth)))
                                        .onSuccess {_ in
                                            isShowingLoadingIndicator = false
                                        }
                                        .resizable()
                                        .scaledToFill()
                                }
                            } else {
                                //TODO: Clean this up after everyone is ported over to imageUrls array
                                KFImage(URL(string: postDetailViewModel.postModel.imageUrl ?? ""))
                                    .onSuccess {_ in
                                        isShowingLoadingIndicator = false
                                    }
                                    .resizable()
                                    .scaledToFill()
                            }
                        if (isShowingLoadingIndicator) {
                            ProgressView()
                        }
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
                                    let eventName = "Like Button - Clicked"
                                    let propertiesDict = ["isLike": false as Bool] as? [String : Bool]
                                    Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                                    Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
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
                                    let eventName = "Like Button - Clicked"
                                    let propertiesDict = ["isLike": true as Bool] as? [String : Bool]
                                    Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                                    Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
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
                            .focused($focusedField, equals: .commentField)
                            .submitLabel(.send)
                            .onSubmit {
                                let eventName = "Submit Comment - Clicked"
                                let propertiesDict = ["commentLength": postDetailViewModel.commentText.count as Int] as? [String : Int]
                                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
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
                            let eventName = "Submit Comment - Clicked"
                            let propertiesDict = ["commentLength": postDetailViewModel.commentText.count as Any] as? [String : Int]
                            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
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
                    "isUsersOwnPost": isUsersOwnPost(),
                    "source": self.source,
                ] as? [String : Any]
                let propertiesDictMixPanel = [
                    "postId": postDetailViewModel.postModel.id as Any,
                    "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
                    "isUsersOwnPost": isUsersOwnPost(),
                    "source": self.source,
                ] as? [String : MixpanelType]
                let eventName = "Post Detail Screen - View"
                Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                Mixpanel.mainInstance().track(event: eventName, properties: propertiesDictMixPanel)
                self.postDetailViewModel.fetchComments()
                self.postDetailViewModel.fetchLikes(userId: authenticationViewModel.userModel?.id)
            }
            .onDisappear {
                self.postDetailViewModel.removeListeners()
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: UserProfileView(userId: postDetailViewModel.postModel.author.userId!)) {
                        if let profilePicImageUrl = postDetailViewModel.postModel.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                            KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)))
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
                    }.disabled(postDetailViewModel.postModel.author.userId?.isEmpty ?? true)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showConfirmationDialog = true
                    }, label: {
                        Image(systemName: "ellipsis")
                    })
                }
            }
            .confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
                if (isUsersOwnPost()) {
                    Button ("Edit Post") {
                        
                    }
                    Button ("Delete Post", role: ButtonRole.destructive) {
                        postDetailViewModel.deletePost()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    Button ("Report Post", role: ButtonRole.destructive) {
                        openMail(postId: postDetailViewModel.postModel.id)
                    }
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
//                Text ("Choose a picture from your photo library, or take one now!")
            }
        }
    }
    
    func openMail(postId: String?) {
        let email = "feedback@fitsatfit.com"
        let subject = "Report%20Post:%20\(postId ?? "no ID")"
        let body = "Please%20let%20us%20know%20why%20you%20want%20to%20report%20this%20post.%20"
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Not handling if they don't have email app
            }
        } else {
            // Not handling if they don't have email app
        }
    }
}
