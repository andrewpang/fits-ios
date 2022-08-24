//
//  ChallengesViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import Foundation
import Firebase

class ChallengesViewModel: ObservableObject {
    
    @Published var challengesData = ChallengesModel()
    @Published var shouldPopToRootViewIfFalse = false

    private var db = Firestore.firestore()
    
    var challengesListener: ListenerRegistration?

    func fetchChallenges() {
        if (challengesListener != nil) {
            return
        }
        
        var fetchChallengesQuery: Query
        fetchChallengesQuery = db.collection("challenges")
            .whereField("endTime", isGreaterThan: Timestamp.init())
            .order(by: "endTime", descending: true)
        
        
        challengesListener = fetchChallengesQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var challengeList = [ChallengeModel]()
            challengeList = documents.compactMap { querySnapshot -> ChallengeModel? in
                return try? querySnapshot.data(as: ChallengeModel.self)
            }
            DispatchQueue.main.async {
                self.challengesData = ChallengesModel(challengeModels: challengeList)
            }
        }
    }
    
    func removeListeners() {
        challengesListener?.remove()
    }
}
