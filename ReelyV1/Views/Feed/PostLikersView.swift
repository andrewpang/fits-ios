//
//  PostLikersView.swift
//  FITs
//
//  Created by Andrew Pang on 9/6/22.
//

import SwiftUI
import Amplitude
import Mixpanel

struct PostLikersView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let likeModels = postDetailViewModel.likersList, !likeModels.isEmpty {
                    ForEach(likeModels, id: \.id) { like in
                        NavigationLink(destination: UserProfileView(userId: like.author.userId!)) {
                            PostLikerRowView(likeModel: like)
                        }.disabled(like.author.userId?.isEmpty ?? true)
                    }
                }
            }
        }.navigationBarTitle("Applauders", displayMode: .inline)
        .onAppear {
            postDetailViewModel.fetchLikers()
            let propertiesDict = [
                "postId": postDetailViewModel.postModel.id as Any,
                "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
                "isUsersOwnPost": isUsersOwnPost(),
            ] as? [String : Any]
            let propertiesDictMixPanel = [
                "postId": postDetailViewModel.postModel.id as Any,
                "postAuthorId": postDetailViewModel.postModel.author.userId as Any,
                "isUsersOwnPost": isUsersOwnPost(),
            ] as? [String : MixpanelType]
            let eventName = "Post Likers Screen - View"
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDictMixPanel)
        }
    }
    
    func isUsersOwnPost() -> Bool {
        return (postDetailViewModel.postModel.author.userId == authenticationViewModel.userModel?.id) as Bool
    }
}
