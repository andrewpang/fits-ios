//
//  CollectionsProfileFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI

struct CollectionsProfileFeedView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack {
            if (!userProfileViewModel.usersBookmarkBoardsList.isEmpty) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(userProfileViewModel.usersBookmarkBoardsList, id: \.id) { bookmarkBoardModel in
                            Button(action: {
                                //
                            }, label: {
                                Text(bookmarkBoardModel.title ?? "title")
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
