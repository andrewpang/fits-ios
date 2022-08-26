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
    @Published var promptPostsData = [PromptPostModel]()
    @Published var postsSeenThisSession = 0
    
    private var db = Firestore.firestore()
    
    let limitTimesToSeeIntroPostOverlay = 5
    let numberOfPostsSeenToShowOverlay = 5
    
    var postsListener: ListenerRegistration?
    var promptPostsListener: ListenerRegistration?
    
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
    
    func fetchPromptPostsForUser(with userId: String) {
        if (promptPostsListener != nil || userId == "noId") {
            return
        }
        let fetchPromptPostsQuery = db.collection("promptPosts")
            .whereField("userId", isEqualTo: userId)
            
        promptPostsListener = fetchPromptPostsQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var promptPostList = [PromptPostModel]()
            promptPostList = documents.compactMap { querySnapshot -> PromptPostModel? in
                return try? querySnapshot.data(as: PromptPostModel.self)
            }
            DispatchQueue.main.async {
                self.promptPostsData = promptPostList
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
    
    func hasUserPostedToPrompt(promptId: String?) -> Bool {
        if let promptId = promptId {
            for promptPost in promptPostsData {
                if (promptPost.promptId == promptId) {
                    return true
                }
            }
        }
        return false
    }
}
