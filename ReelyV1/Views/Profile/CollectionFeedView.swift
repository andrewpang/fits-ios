//
//  CollectionFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import SwiftUI

struct CollectionFeedView: View {
    
    @ObservedObject var bookmarkBoardViewModel: BookmarkBoardViewModel
    @State var postDetailViewModel: PostDetailViewModel = PostDetailViewModel(postModel: PostModel(author: PostAuthorMap(), imageUrl: "", title: "", body: "")) //Initial default value
    
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
        .onAppear {
            self.bookmarkBoardViewModel.fetchPostsForBookmarkBoard()
            self.bookmarkBoardViewModel.fetchCreatorName()
        }
    }
}

