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
    @Published var shouldPopToRootViewIfFalse = false
    @Published var shouldScrollToTop = false
    
    @Published var postsSeenThisSession = 0
    
    private var db = Firestore.firestore()
    
    let limitTimesToSeeIntroPostOverlay = 5
    let numberOfPostsSeenToShowOverlay = 5
    
    var postsListener: ListenerRegistration?

    func fetchPosts(isAdmin: Bool) {
        if (postsListener != nil) {
            return
        }
        
        var fetchPostQuery: Query
        if (isAdmin) {
            fetchPostQuery = db.collection("posts")
                .order(by: "createdAt", descending: true)
        } else {
            fetchPostQuery = db.collection("posts")
                .whereField("groupId", isEqualTo: Constants.FITGroupId)
                .order(by: "createdAt", descending: true)
        }
        
        postsListener = fetchPostQuery.addSnapshotListener { (querySnapshot, error) in
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
    
    func checkIfShouldShowIntroPostOverlay() {
        let numberOfTimesSeenIntroPostOverlay = UserDefaults.standard.integer(forKey: "numberOfTimesSeenIntroPostOverlay")
        guard (UserDefaults.standard.bool(forKey: "hasPostedIntroPost") == true || numberOfTimesSeenIntroPostOverlay > limitTimesToSeeIntroPostOverlay || postsSeenThisSession != numberOfPostsSeenToShowOverlay) else {
            self.showIntroPostOverlay = true
            UserDefaults.standard.set(numberOfTimesSeenIntroPostOverlay + 1, forKey: "numberOfTimesSeenIntroPostOverlay")
            return
        }
    }
    
    func setIntroPostMade() {
        showIntroPostOverlay = false
        UserDefaults.standard.set(true, forKey: "hasPostedIntroPost")
    }
}
