//
//  CollectionFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import SwiftUI

struct CollectionFeedView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var bookmarkBoardViewModel: BookmarkBoardViewModel
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    @State var showConfirmationDialog = false
    @State var showingDeleteAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func isUsersOwnCollection() -> Bool {
        return (bookmarkBoardViewModel.bookmarkBoardModel.creatorId == authenticationViewModel.userModel?.id) as Bool
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PostDetailView(postDetailViewModel: postDetailViewModel, source: "homeFeed"), isActive: $bookmarkBoardViewModel.shouldPopToRootViewIfFalse) {
                EmptyView()
            }
            .isDetailLink(false)
            Color(Constants.backgroundColor).ignoresSafeArea()
            VStack(spacing: 0) {
                Text(bookmarkBoardViewModel.bookmarkBoardModel.title ?? "Board")
                    .font(Font.custom(Constants.titleFontItalicized, size: 32))
                if (!bookmarkBoardViewModel.creatorName.isEmpty) {
                    Text("Created by: \(bookmarkBoardViewModel.creatorName)")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .multilineTextAlignment(.center)
                }
                if let postModels = bookmarkBoardViewModel.postsData.postModels {
                    BoardWaterfallCollectionView(bookmarkBoardViewModel: bookmarkBoardViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController()).onAppear {
//                        let eventName = "Home Feed Screen - View"
//                        let propertiesDict = ["feed": "Random"] as? [String : String]
//                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                        Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                    }.padding(.top, 16)
                } else {
                    Spacer()
                    Text("There's no posts in this collection :(")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }.navigationBarTitle("", displayMode: .inline)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showConfirmationDialog = true
                }, label: {
                    Image(systemName: "ellipsis")
                        .padding(.vertical, 16)
                })
            }
        }
        .confirmationDialog("Select a Photo", isPresented: $showConfirmationDialog) {
            if (isUsersOwnCollection()) {
                Button ("Edit Post") {
//                    editPostTitle = postDetailViewModel.postModel.title
//                    editPostBody = postDetailViewModel.postModel.body
//                    isEditMode = true
//                    focusedField = .editPostTitleField
                }
                Button ("Delete Collection", role: ButtonRole.destructive) {
                    showingDeleteAlert = true
                }
            } else {
                Button ("Report Collection", role: ButtonRole.destructive) {
//                    openMail(postId: postDetailViewModel.postModel.id)
                }
            }
            Button ("Cancel", role: ButtonRole.cancel) {}
        } message: {
                Text ("Choose a picture from your photo library, or take one now!")
        }.alert("Delete Collection", isPresented: $showingDeleteAlert, actions: {
              Button("No", role: .cancel, action: {})
              Button("Delete", role: .destructive, action: {
                  self.bookmarkBoardViewModel.deleteBookmarkBoard()
                  self.presentationMode.wrappedValue.dismiss()
//                  let eventName = "Delete Post - Clicked"
//                  let propertiesDict = ["userId": authenticationViewModel.userModel?.id, "postId": postDetailViewModel.postModel.id ?? "noId"] as? [String : String]
//                  Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//                  Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
              })
            }, message: {
                Text("Are you sure you want to delete this collection? (You can't undo this)")
            })
        .onAppear {
            self.bookmarkBoardViewModel.fetchPostsForBookmarkBoard()
            self.bookmarkBoardViewModel.fetchCreatorName()
        }
    }
}

