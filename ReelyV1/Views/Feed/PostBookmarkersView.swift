//
//  PostBookmarkersView.swift
//  FITs
//
//  Created by Andrew Pang on 9/27/22.
//

import SwiftUI

struct PostBookmarkersView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let bookmarks = postDetailViewModel.bookmarksList, !bookmarks.isEmpty {
                    ForEach(bookmarks, id: \.id) { bookmark in
                        NavigationLink(destination: UserProfileView(userId: bookmark.bookmarkerId!)) {
                            FollowerRowView(userId: bookmark.bookmarkerId!)
                        }.isDetailLink(false)
                        .disabled(bookmark.bookmarkerId?.isEmpty ?? true)
                    }
                }
            }
        }.navigationBarTitle("Bookmarkers", displayMode: .inline)
        .onAppear {
            postDetailViewModel.fetchBookmarkers()
//            let propertiesDict = [
//                "postId": postDetailViewModel.postModel.id as Any,
//                "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
//                "isUsersOwnPost": isUsersOwnPost(),
//            ] as? [String : Any]
//            let propertiesDictMixPanel = [
//                "postId": postDetailViewModel.postModel.id as Any,
//                "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
//                "isUsersOwnPost": isUsersOwnPost(),
//            ] as? [String : MixpanelType]
//            let eventName = "Post Likers Screen - View"
//            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
//            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDictMixPanel)
        }
    }
}
