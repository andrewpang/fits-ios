//
//  CollectionsProfileFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/23/22.
//

import SwiftUI

struct CollectionsProfileView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var bookmarkBoardViewModel = BookmarkBoardViewModel(bookmarkBoardModel: BookmarkBoardModel()) //Initial default value
    @State var showCollectionFeedView = false
    
    func isUsersOwnProfile() -> Bool {
        return (userProfileViewModel.userModel?.id == authenticationViewModel.userModel?.id) as Bool
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: CollectionFeedView(bookmarkBoardViewModel: bookmarkBoardViewModel), isActive: $showCollectionFeedView) {
                EmptyView()
            }
            .isDetailLink(false)
            if (!userProfileViewModel.usersBookmarkBoardsList.isEmpty) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        Button(action: {
                            self.bookmarkBoardViewModel = BookmarkBoardViewModel()
                            self.showCollectionFeedView = true
                        }, label: {
                            HStack {
                                Text("All Saved Posts")
                                    .font(Font.custom(Constants.bodyFont, size: 18))
                                    .padding(.horizontal, 8)
                                    .foregroundColor(Color(Constants.darkBackgroundColor))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(.gray)
                            }.padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        })
                        ForEach(userProfileViewModel.usersBookmarkBoardsList, id: \.id) { bookmarkBoardModel in
                            Button(action: {
                                self.bookmarkBoardViewModel = BookmarkBoardViewModel(bookmarkBoardModel: bookmarkBoardModel)
                                self.showCollectionFeedView = true
                            }, label: {
                                CollectionsProfileRowView(bookmarkBoardModel: bookmarkBoardModel)
                            })
                        }
                    }.padding(.bottom, 16)
                }
            } else {
                if (isUsersOwnProfile()) {
                    Text("You have no posts saved to your collections yet!")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 40)
                        .multilineTextAlignment(.center)
                } else {
                    Text("This user has no posts saved to their collections yet!")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 40)
                        .multilineTextAlignment(.center)
                }
            }
        }.onAppear {
            userProfileViewModel.fetchBookmarkBoardsForUser(with: userProfileViewModel.userModel?.id ?? "noId")
        }
    }
}
