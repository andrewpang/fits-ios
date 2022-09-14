//
//  FollowingListView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI

struct FollowingListView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let followingModels = authenticationViewModel.followingData, !followingModels.isEmpty {
                    ForEach(followingModels, id: \.id) { following in
                        if let userId = following.id {
                            NavigationLink(destination: UserProfileView(userId: userId)) {
                                FollowerFollowingRowView(userId: userId)
                            }.isDetailLink(false)
                        }
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .onAppear {
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

struct FollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingListView()
    }
}
