//
//  FollowerListView.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import SwiftUI
import Amplitude
import Mixpanel

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
            authenticationViewModel.getFollowersList()
            let eventName = "Follower List - View"
            Amplitude.instance().logEvent(eventName)
            Mixpanel.mainInstance().track(event: eventName)
        }
    }
}

struct FollowerListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerListView()
    }
}
