//
//  FollowerListView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI

struct FollowerListView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let followers = authenticationViewModel.followerData.users, !followers.isEmpty {
                    ForEach(followers, id: \.self) { follower in
                        NavigationLink(destination: UserProfileView(userId: follower)) {
                            FollowerRowView(userId: follower)
                        }.isDetailLink(false)
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .onAppear {
            print("follower list view")
            authenticationViewModel.getFollowingList()
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

struct FollowerListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerListView()
    }
}
