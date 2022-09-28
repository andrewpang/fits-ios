//
//  PostLikerBookmarkerParentView.swift
//  FITs
//
//  Created by Andrew Pang on 9/27/22.
//

import SwiftUI

struct PostLikerBookmarkerParentView: View {
    
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @State var selectedTab = 0
    static let likerTabIndex = 0
    static let bookmarkerTabIndex = 1
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Applauds").font(Font.custom(Constants.bodyFont, size: 16)).tag(FollowerFollowingParentView.followersTabIndex)
                Text("Saves").font(Font.custom(Constants.bodyFont, size: 16)).tag(FollowerFollowingParentView.followingTabIndex)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            Text("This list is only visible to you").font(Font.custom(Constants.bodyFont, size: 12))
            Spacer()
            switch (selectedTab) {
                case PostLikerBookmarkerParentView.likerTabIndex: PostLikersView(postDetailViewModel: postDetailViewModel)
                case PostLikerBookmarkerParentView.bookmarkerTabIndex: PostSavesView(postDetailViewModel: postDetailViewModel)
                default: PostLikersView(postDetailViewModel: postDetailViewModel)
            }
        }
    }
}
