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
import ConfettiSwiftUI
import PopupView

struct PostDetailView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showConfirmationDialog = false
    @State var showUnfollowConfirmationDialog = false
    @State var isEditMode = false
    @State var showingDeleteAlert = false
    @State var editPostTitle = ""
    @State var editPostBody = ""
    @State var isAnimatingApplaud = false
    @State private var confettiCounterOne: Int = 0
    @State private var confettiCounterTwo: Int = 0
    @State var goToApplaudsPage = false
    @State var goToSavesPage = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var source = "homeFeed"
    
    let generator = UINotificationFeedbackGenerator()
    
    enum PostDetailFocusField: Hashable {
        case commentField
        case editPostTitleField
    }
   
    @FocusState var focusedField: PostDetailFocusField?
    @State var isShowingLoadingIndicator = true
    
    func isUsersOwnPost() -> Bool {
        return (postDetailViewModel.postModel.author.userId == authenticationViewModel.userModel?.id) as Bool
    }
    
    func animateApplaud() {
        confettiCounterOne += 1
        isAnimatingApplaud = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.isAnimatingApplaud = false
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
    
    var body: some View {
        GeometryReader { geometry in
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
                                                .scaledToFit()
                                        }
                                    }
                                    .frame(height: geometry.size.width)
                                    .tabViewStyle(PageTabViewStyle())
                                    .onTapGesture(count: 2) {
                                        animateApplaud()
                                        generator.notificationOccurred(.success)
                                        if (!postDetailViewModel.isLiked) {
                                            likePostFirebaseAndAnalytics()
                                        }
                                    }
                                } else {
                                    KFImage(URL(string: CloudinaryHelper.getCompressedUrl(url: postDetailViewModel.postModel.imageUrls?[0] ?? "", width: CloudinaryHelper.detailWidth)))
                                        .onSuccess {_ in
                                            isShowingLoadingIndicator = false
                                        }
                                        .resizable()
                                        .scaledToFill()
                                        .onTapGesture(count: 2) {
                                            animateApplaud()
                                            generator.notificationOccurred(.success)
                                            if (!postDetailViewModel.isLiked) {
                                                likePostFirebaseAndAnalytics()
                                            }
                                        }
                                }
                            } else {
                                //TODO: Clean this up after everyone is ported over to imageUrls array
                                KFImage(URL(string: postDetailViewModel.postModel.imageUrl ?? ""))
                                    .onSuccess {_ in
                                        isShowingLoadingIndicator = false
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .onTapGesture(count: 2) {
                                        animateApplaud()
                                        generator.notificationOccurred(.success)
                                        if (!postDetailViewModel.isLiked) {
                                            likePostFirebaseAndAnalytics()
                                        }
                                    }
                            }
                            if (isShowingLoadingIndicator) {
                                ProgressView()
                            }
                            Image(systemName: "hands.clap.fill")
                                .font(.system(size: 64.0, weight: .light))
                                .foregroundColor(Color("FITColor"))
                                .opacity(isAnimatingApplaud ? 1.0 : 0)
                                .scaleEffect(isAnimatingApplaud ? 1.0 : 0)
                                .animation(.easeInOut(duration: isAnimatingApplaud ? 0.25 : 1.0), value: isAnimatingApplaud)
                        }.confettiCannon(counter: $confettiCounterOne, num: 30, confettis: [.text("👏"), .text("💙"), .text("🔥"), .text("🎉"), .text("👏🏿")], confettiSize: 30)
                        
                        if (isEditMode) {
                            Text("Post Title:")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .padding(.top, 16)
                                .padding(.horizontal, 24)
                            Text("Required (Max. 30 Characters)")
                                .font(Font.custom(Constants.bodyFont, size: 12))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                            TextField("Title", text: $editPostTitle)
                                .font(Font.custom(Constants.titleFont, size: 16))
//                                    .disabled(postViewModel.isSubmitting)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($focusedField, equals: .editPostTitleField)
                                .onReceive(editPostTitle.publisher.collect()) {
                                    let s = String($0.prefix(Constants.postTitleCharacterLimit))
                                    if editPostTitle != s {
                                        editPostTitle = s
                                    }
                                  }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                            
                            Text("Note:")
                                .font(Font.custom(Constants.titleFontBold, size: 16))
                                .padding(.horizontal, 24)
                            Text("Required (Max. 500 Characters)")
                                .font(Font.custom(Constants.bodyFont, size: 12))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                            ZStack {
                                TextEditor(text: $editPostBody)
                                    .font(Font.custom(Constants.bodyFont, size: 16))
//                                        .disabled(postViewModel.isSubmitting)
                                Text(editPostBody).opacity(0).padding(.all, 8)
                                    .font(Font.custom(Constants.bodyFont, size: 16))
                            }.overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray).opacity(0.3))
                            .frame(minHeight: 100)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                        } else {
                            if let promptTitle = postDetailViewModel.postModel.prompt?.title {
                                HStack {
                                    Spacer()
                                    Text("Fit Check:")
                                        .font(Font.custom(Constants.titleFontItalicized, size: 16))
                                        .foregroundColor(Color(Constants.backgroundColor))
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }.padding(.top, 16)
                                .padding(.horizontal, 16)
                                .background(Color(Constants.darkBackgroundColor))
                                HStack {
                                    Spacer()
                                    Text(promptTitle)
                                        .font(Font.custom(Constants.titleFont, size: 18))
                                        .foregroundColor(Color(Constants.backgroundColor))
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }.padding(.bottom, 16)
                                .padding(.horizontal, 16)
                                .background(Color(Constants.darkBackgroundColor))
                            }
                            
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
                        }
     
                        if (!isEditMode) {
                            HStack {
        //                        Spacer()
                                if (postDetailViewModel.isLiked) {
                                    Button(action: {
                                        generator.notificationOccurred(.error)
                                        postDetailViewModel.unlikePost(userId: authenticationViewModel.userModel?.id)
                                        let eventName = "Like Button - Clicked"
                                        let propertiesDict = ["isLike": false as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : Any]
                                        let mixpanelDict = ["isLike": false as Bool, "source": "postDetail", "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : MixpanelType]
                                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                                    }, label: {
                                        Image(systemName: "hands.clap.fill")
                                            .font(.system(size: 28.0, weight: .light))
                                            .foregroundColor(Color("FITColor"))
                                            .scaleEffect(isAnimatingApplaud ? 1.25 : 1.0)
                                            .animation(.easeInOut(duration: isAnimatingApplaud ? 0.25 : 1.0), value: isAnimatingApplaud)
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
                                        confettiCounterTwo += 1
                                        generator.notificationOccurred(.success)
                                        likePostFirebaseAndAnalytics()
                                    }, label: {
                                        Image(systemName: "hands.clap")
                                            .font(.system(size: 28.0, weight: .light))
                                            .foregroundColor(.gray)
                                            .scaleEffect(isAnimatingApplaud ? 1.25 : 1.0)
                                            .animation(.easeInOut(duration: isAnimatingApplaud ? 0.25 : 1.0), value: isAnimatingApplaud)
//                                        if (postDetailViewModel.postModel.likesCount ?? 0 > 0) {
                                        Text("Applauded by others!")
                                            .font(Font.custom(Constants.bodyFont, size: 16))
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 4)
//                                        } else {
//                                            Text("Be the first to applaud!")
//                                                .font(Font.custom(Constants.bodyFont, size: 16))
//                                                .foregroundColor(.gray)
//                                                .padding(.horizontal, 4)
//                                        }
                                    })
                                }
                                Spacer()
                            }.padding(.horizontal, 24)
                            .confettiCannon(counter: $confettiCounterTwo, num: 30, confettis: [.text("👏"), .text("💙"), .text("🔥"), .text("🎉"), .text("👏🏿")], confettiSize: 30)
                            
                            if (postDetailViewModel.postModel.author.userId == authenticationViewModel.userModel?.id) {
                                HStack {
                                    Spacer()
                                    NavigationLink(destination: PostLikerBookmarkerParentView(postDetailViewModel: postDetailViewModel), isActive: $goToApplaudsPage) {
                                        HStack {
                                            Text("View Applauds/Saves")
                                                .font(Font.custom(Constants.buttonFont, size: 16))
                                                .foregroundColor(Color(Constants.backgroundColor))
                                                .padding(.vertical, 12)
                                                .padding(.horizontal, 24)
                                        }
                                        .background(Color("FITColor"))
                                        .cornerRadius(Constants.buttonCornerRadius)
                                    }.isDetailLink(false)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 24)
                                    NavigationLink(destination: PostLikerBookmarkerParentView(postDetailViewModel: postDetailViewModel, selectedTab: PostLikerBookmarkerParentView.bookmarkerTabIndex), isActive: $goToSavesPage) {
                                        EmptyView()
                                    }.isDetailLink(false)
                                    Spacer()
                                }
                            }
                            
                            Divider()
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                            
                            CommentsView(postDetailViewModel: postDetailViewModel, focusedField: _focusedField)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 8)
                        }
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                if (!isEditMode) {
                    Divider()
                    CommentBarView(postDetailViewModel: postDetailViewModel, focusedField: _focusedField)
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
                self.postDetailViewModel.fetchUserHasBookmarkedPost(userId: authenticationViewModel.userModel?.id)
            }
            .onDisappear {
                self.postDetailViewModel.removeListeners()
            }.toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if (isEditMode) {
                        Button("Cancel") {
                            isEditMode = false
                        }
                        .foregroundColor(Color.gray)
                    } else {
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
                        }.isDetailLink(false)
                        .disabled(postDetailViewModel.postModel.author.userId?.isEmpty ?? true)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if (!isEditMode && !isUsersOwnPost()) {
                        if (authenticationViewModel.isFollowingUser(with: postDetailViewModel.postModel.author.userId!)) {
                            HStack {
                                Text("Following")
                                    .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                    .padding(.horizontal, 4)
                                    .fixedSize()
                            }.padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(Constants.backgroundColor))
                            .foregroundColor(Color(Constants.darkBackgroundColor))
                            .cornerRadius(10)
                            .onTapGesture {
                                showUnfollowConfirmationDialog = true
                                generator.notificationOccurred(.warning)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(Constants.darkBackgroundColor), lineWidth: 1)
                            )
                        } else {
                            HStack {
                                if (authenticationViewModel.isUserFollowingCurrentUser(with: postDetailViewModel.postModel.author.userId!)) {
                                    Text("Follow Back")
                                        .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                        .padding(.horizontal, 4)
                                        .fixedSize()
                                } else {
                                    Text("Follow")
                                        .font(Font.custom(Constants.bodyFont, size: Constants.followButtonTextSize))
                                        .padding(.horizontal, 4)
                                        .fixedSize()
                                }
                            }.padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color(Constants.darkBackgroundColor))
                            .foregroundColor(Color(Constants.backgroundColor))
                            .cornerRadius(10)
                            .onTapGesture {
                                authenticationViewModel.followUser(with: postDetailViewModel.postModel.author.userId!)
                                generator.notificationOccurred(.success)
                            }
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if (isEditMode) {
                        Button(action: {
                            postDetailViewModel.editPost(title: editPostTitle, body: editPostBody)
                            isEditMode = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            let eventName = "Edit Post - Clicked"
                            let propertiesDict = ["userId": authenticationViewModel.userModel?.id, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : String]
                            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                        }) {
                            if (editPostTitle.isEmpty || editPostBody.isEmpty) {
                                HStack {
                                   Text("Done")
                                        .font(Font.custom(Constants.bodyFont, size: 16))
                                }.padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .opacity(0.75)
                            } else {
                                HStack {
                                    if (postDetailViewModel.isSubmittingEditPost) {
                                        Text("Loading...")
                                            .font(Font.custom(Constants.bodyFont, size: 16))
                                    } else {
                                        Text("Done")
                                            .font(Font.custom(Constants.bodyFont, size: 16))
                                    }
                                }.padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .disabled(self.postDetailViewModel.isSubmittingEditPost || editPostTitle.isEmpty || editPostBody.isEmpty)
                    } else {
                        Button(action: {
                            showConfirmationDialog = true
                        }, label: {
                            Image(systemName: "ellipsis")
                                .padding(.vertical, 16)
                        })
                    }
                }
            }
            .confirmationDialog("Unfollow User", isPresented: $showUnfollowConfirmationDialog) {
                Button ("Unfollow", role: ButtonRole.destructive) {
                    authenticationViewModel.unfollowUser(with: postDetailViewModel.postModel.author.userId!)
                    generator.notificationOccurred(.warning)
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
                Text ("Are you sure you want to stop following this user?")
            }
            .confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
                if (isUsersOwnPost()) {
                    Button ("View Applauds") {
                        self.goToApplaudsPage = true
                    }
                    Button ("View Saves") {
                        self.goToSavesPage = true
                    }
                    Button ("Edit Post") {
                        editPostTitle = postDetailViewModel.postModel.title
                        editPostBody = postDetailViewModel.postModel.body
                        isEditMode = true
                        focusedField = .editPostTitleField
                    }
                    Button ("Delete Post", role: ButtonRole.destructive) {
                        showingDeleteAlert = true
                    }
                } else {
                    Button ("Report Post", role: ButtonRole.destructive) {
                        openMail(postId: postDetailViewModel.postModel.id)
                    }
                }
                Button ("Cancel", role: ButtonRole.cancel) {}
            } message: {
//                Text ("Choose a picture from your photo library, or take one now!")
            }.alert("Delete Post", isPresented: $showingDeleteAlert, actions: {
                  Button("No", role: .cancel, action: {})
                  Button("Delete", role: .destructive, action: {
                      postDetailViewModel.deletePost()
                      self.presentationMode.wrappedValue.dismiss()
                      let eventName = "Delete Post - Clicked"
                      let propertiesDict = ["userId": authenticationViewModel.userModel?.id, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : String]
                      Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                      Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                  })
                }, message: {
                    Text("Are you sure you want to delete your post? (You can't undo this)")
                })
            .navigationBarBackButtonHidden(isEditMode)
        }.popup(isPresented: $postDetailViewModel.isShowingBookmarkPopup, type: .floater(verticalPadding: 80, useSafeAreaInset: true), position: .bottom, autohideIn: 3, closeOnTap: false) {
            HStack {
                Text("✅")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                Text("Added to Collections")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(Color(Constants.backgroundColor))
                Spacer()
                Button(action: {
                    postDetailViewModel.isShowingBoardsSheet = true
                }, label: {
                    HStack(spacing: 4) {
                        Text("Manage")
                            .font(Font.custom(Constants.titleFontBold, size: 16))
                            .foregroundColor(Color(Constants.backgroundColor))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16.0))
                            .foregroundColor(Color(Constants.backgroundColor))
                    }
                }).padding(.trailing, 16)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .background(Color(Constants.darkBackgroundColor))
            .opacity(0.9)
            .cornerRadius(Constants.buttonCornerRadius)
            .padding(.horizontal, 16)
        }
        .popup(isPresented: $postDetailViewModel.isShowingSavedToBoardPopup, type: .floater(verticalPadding: 16, useSafeAreaInset: true), position: .top, autohideIn: 2) {
            HStack {
                Text("📌")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(.white)
                Text("Saved to Collection")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(Color(Constants.backgroundColor))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(Constants.darkBackgroundColor))
            .opacity(0.9)
            .cornerRadius(Constants.buttonCornerRadius)
        }
        .popup(isPresented: $postDetailViewModel.isShowingRemovedFromCollectionsPopup, type: .floater(verticalPadding: 16, useSafeAreaInset: true), position: .top, autohideIn: 2) {
            HStack {
                Text("🙅‍♀️")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(.white)
                Text("Removed from collections")
                    .font(Font.custom(Constants.buttonFont, size: 16))
                    .foregroundColor(Color(Constants.backgroundColor))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color(Constants.darkBackgroundColor))
            .opacity(0.9)
            .cornerRadius(Constants.buttonCornerRadius)
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
