//
//  FollowerFollowingParentView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI

struct FollowerFollowingParentView: View {
    
    @State var selectedTab = 0
    static let followersTabIndex = 0
    static let followingTabIndex = 1
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Followers").font(Font.custom(Constants.bodyFont, size: 16)).tag(FollowerFollowingParentView.followersTabIndex)
                Text("Following").font(Font.custom(Constants.bodyFont, size: 16)).tag(FollowerFollowingParentView.followingTabIndex)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            Text("This list is only visible to you").font(Font.custom(Constants.bodyFont, size: 12))
            Spacer()
            switch (selectedTab) {
                case FollowerFollowingParentView.followersTabIndex: FollowerListView()
                case FollowerFollowingParentView.followingTabIndex: FollowingListView()
                default: FollowerListView()
            }
        }
    }
}

struct FollowerFollowingParentView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerFollowingParentView()
    }
}
