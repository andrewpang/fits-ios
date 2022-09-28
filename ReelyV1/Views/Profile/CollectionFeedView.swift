//
//  CollectionFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import SwiftUI
import Amplitude
import Mixpanel

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
                if let boardTitle = bookmarkBoardViewModel.bookmarkBoardModel.title, !boardTitle.isEmpty {
                    Text(boardTitle)
                        .font(Font.custom(Constants.titleFontItalicized, size: 32))
                }
                if (!bookmarkBoardViewModel.creatorName.isEmpty) {
                    Text("Created by: \(bookmarkBoardViewModel.creatorName)")
                        .font(Font.custom(Constants.bodyFont, size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                }
                if let postModels = bookmarkBoardViewModel.postsData.postModels {
                    BoardWaterfallCollectionView(bookmarkBoardViewModel: bookmarkBoardViewModel, selectedPostDetail: $postDetailViewModel, uiCollectionViewController: UICollectionViewController())
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
            if (isUsersOwnCollection() && !bookmarkBoardViewModel.showAllPosts) {
                //TODO: Edit Post
                Button ("Delete Collection", role: ButtonRole.destructive) {
                    showingDeleteAlert = true
                }
            }
            else {
                Button ("Report Collection", role: ButtonRole.destructive) {
                    openMail(bookmarkBoardId: bookmarkBoardViewModel.bookmarkBoardModel.id)
                }
            }
            Button ("Cancel", role: ButtonRole.cancel) {}
        } message: {
//                Text ("Choose a picture from your photo library, or take one now!")
        }.alert("Delete Collection", isPresented: $showingDeleteAlert, actions: {
              Button("No", role: .cancel, action: {})
              Button("Delete", role: .destructive, action: {
                  self.bookmarkBoardViewModel.deleteBookmarkBoard()
                  self.presentationMode.wrappedValue.dismiss()
                  let eventName = "Delete Board - Clicked"
                  let propertiesDict = ["userId": authenticationViewModel.userModel?.id, "boardId": bookmarkBoardViewModel.bookmarkBoardModel.id ?? "noId"] as? [String : String]
                  Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                  Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
              })
            }, message: {
                Text("Are you sure you want to delete this collection? (You can't undo this)")
            })
        .onAppear {
            self.bookmarkBoardViewModel.fetchPostsForBookmarkBoard(with: bookmarkBoardViewModel.bookmarkBoardModel.creatorId ?? "noId")
            self.bookmarkBoardViewModel.fetchCreatorName()
            self.bookmarkBoardViewModel.fetchPostLikesForUser(with: authenticationViewModel.userModel?.id ?? "noId")
            let eventName = "Collection Feed - View"
            let propertiesDict = ["isUsersOwnProfile": isUsersOwnCollection(), "boardId": bookmarkBoardViewModel.bookmarkBoardModel.id ?? "noId", "creatorId": bookmarkBoardViewModel.bookmarkBoardModel.creatorId ?? "noId"] as? [String : Any]
            let mixpanelDict = ["isUsersOwnProfile": isUsersOwnCollection(), "boardId": bookmarkBoardViewModel.bookmarkBoardModel.id ?? "noId", "creatorId": bookmarkBoardViewModel.bookmarkBoardModel.creatorId ?? "noId"]  as? [String : MixpanelType]
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
        }
    }
    
    func openMail(bookmarkBoardId: String?) {
        let email = "feedback@fitsatfit.com"
        let subject = "Report%20Board:%20\(bookmarkBoardId ?? "no ID")"
        let body = "Please%20let%20us%20know%20why%20you%20want%20to%20report%20this%20board.%20"
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

