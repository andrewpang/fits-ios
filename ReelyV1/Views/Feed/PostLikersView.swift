//
//  PostLikersView.swift
//  FITs
//
//  Created by Andrew Pang on 9/6/22.
//

import SwiftUI

struct PostLikersView: View {
    @ObservedObject var postDetailViewModel: PostDetailViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let likeModels = postDetailViewModel.likersList, !likeModels.isEmpty {
                    ForEach(likeModels, id: \.id) { like in
                        NavigationLink(destination: UserProfileView(userId: like.author.userId!)) {
                            PostLikerRowView(likeModel: like)
                        }.disabled(like.author.userId?.isEmpty ?? true)
//                            .padding(.vertical, 8)
                    }
                }
            }
        }.navigationBarTitle("Applauders", displayMode: .inline)
        .onAppear {
            postDetailViewModel.fetchLikers()
        }
    }
}
