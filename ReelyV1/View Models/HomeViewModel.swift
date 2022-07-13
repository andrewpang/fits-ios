//
//  HomeViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    
    @Published var postsData = PostsModel()
    @Published var showIntroPostOverlay = false
    
    private var db = Firestore.firestore()
    
    let limitTimesToSeeIntroPostOverlay = 5

    func fetchPosts(isAdmin: Bool) {
        var fetchPostQuery: Query
        if (isAdmin) {
            fetchPostQuery = db.collection("posts")
                .order(by: "createdAt", descending: true)
        } else {
            fetchPostQuery = db.collection("posts")
                .whereField("groupId", isEqualTo: Constants.FITGroupId)
                .order(by: "createdAt", descending: true)
        }
        
        fetchPostQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var postList = [PostModel]()
            postList = querySnapshot!.documents.compactMap { querySnapshot -> PostModel? in
                return try? querySnapshot.data(as: PostModel.self)
            }
            DispatchQueue.main.async {
                self.postsData = PostsModel(postModels: postList)
            }
        }
    }
    
    func checkIfShouldShowIntroPostOverlay() {
        self.showIntroPostOverlay = true
//        let numberOfTimesSeenIntroPostOverlay = UserDefaults.standard.integer(forKey: "numberOfTimesSeenIntroPostOverlay") + 1
//        UserDefaults.standard.set(numberOfTimesSeenIntroPostOverlay, forKey: "numberOfTimesSeenIntroPostOverlay")
//        guard (UserDefaults.standard.bool(forKey: "hasPostedIntroPost") == true || numberOfTimesSeenIntroPostOverlay > limitTimesToSeeIntroPostOverlay) else {
//            self.showIntroPostOverlay = true
//            return
//        }
    }
    
    func setIntroPostMade() {
        showIntroPostOverlay = false
        UserDefaults.standard.set(true, forKey: "hasPostedIntroPost")
    }
}
