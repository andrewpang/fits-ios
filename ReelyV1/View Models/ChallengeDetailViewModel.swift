//
//  ChallengeDetailViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import Foundation
import Firebase

class ChallengeDetailViewModel: ObservableObject {
    
    @Published var detailViewIsActive = false
    
    @Published var challengeModel: ChallengeModel
    @Published var postsData = PostsModel()

    private var db = Firestore.firestore()
    
    var challengePostListener: ListenerRegistration?
    
    init(challengeModel: ChallengeModel) {
        self.challengeModel = challengeModel
    }
    
    func fetchPostsForChallenge() {
        if (challengePostListener != nil) {
            return
        }
        
        var fetchChallengePostsQuery: Query
        fetchChallengePostsQuery = db.collection("posts")
            .whereField("challenge.challengeId", isEqualTo: challengeModel.id)
            .order(by: "createdAt", descending: true)
        
        challengePostListener = fetchChallengePostsQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var postList = [PostModel]()
            postList = documents.compactMap { querySnapshot -> PostModel? in
                return try? querySnapshot.data(as: PostModel.self)
            }
            DispatchQueue.main.async {
                self.postsData = PostsModel(postModels: postList)
            }
        }
        
    }
    
    func resetData() {
        challengeModel = ChallengeModel(title: "")
        postsData = PostsModel()
    }
}

