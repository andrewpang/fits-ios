//
//  CollectionsProfileFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI

struct CollectionsProfileFeedView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var bookmarkBoardViewModel = BookmarkBoardViewModel(bookmarkBoardModel: BookmarkBoardModel()) //Initial default value
    @State var showCollectionFeedView = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: CollectionFeedView(bookmarkBoardViewModel: bookmarkBoardViewModel), isActive: $showCollectionFeedView) {
                EmptyView()
            }
            .isDetailLink(false)
            if (!userProfileViewModel.usersBookmarkBoardsList.isEmpty) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(userProfileViewModel.usersBookmarkBoardsList, id: \.id) { bookmarkBoardModel in
                            Button(action: {
                                self.bookmarkBoardViewModel = BookmarkBoardViewModel(bookmarkBoardModel: bookmarkBoardModel)
                                self.showCollectionFeedView = true
                            }, label: {
                                CollectionsProfileRowView(bookmarkBoardModel: bookmarkBoardModel)
                            })
                        }
                    }
                }
            } else {
                Text("No collections")
            }
        }.onAppear {
            userProfileViewModel.fetchBookmarkBoardsForUser(with: userProfileViewModel.userModel?.id ?? "noId")
        }
    }
}
