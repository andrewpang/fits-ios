//
//  FollowingListView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI
import Amplitude
import Mixpanel

struct FollowingListView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let followingModels = authenticationViewModel.followingData, !followingModels.isEmpty {
                    ForEach(followingModels, id: \.id) { following in
                        if let userId = following.id {
                            NavigationLink(destination: UserProfileView(userId: userId)) {
                                FollowingRowView(userId: userId)
                            }.isDetailLink(false)
                        }
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .onAppear {
            authenticationViewModel.getFollowingList()
            let eventName = "Following List - View"
            Amplitude.instance().logEvent(eventName)
            Mixpanel.mainInstance().track(event: eventName)
        }
    }
}

struct FollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingListView()
    }
}
