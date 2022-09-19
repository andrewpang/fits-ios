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
    @Published var randomizedPostsData = PostsModel()
    @Published var followingPostsData = PostsModel()
    @Published var showIntroPostOverlay = false
    @Published var shouldPopToRootViewIfFalse = false
    @Published var shouldScrollToTopFollowing = false
    @Published var shouldScrollToTopForYou = false
    @Published var shouldScrollToTopMostRecent = false
    @Published var promptPostsData = [PromptPostModel]()
    @Published var postsSeenThisSession = 0
    @Published var postsUserHasLikedList = [String]()
    @Published var currentTab = 1
    
    private var db = Firestore.firestore()
    
    let limitTimesToSeeIntroPostOverlay = 5
    let numberOfPostsSeenToShowOverlay = 5
    
    var postsListener: ListenerRegistration?
    var promptPostsListener: ListenerRegistration?
    var likesListener: ListenerRegistration?
    var followingUsersListener: ListenerRegistration?
    var followingPostsListener: ListenerRegistration?
    
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
                //Don't randomize everytime there's a new post or update
                if (self.randomizedPostsData.postModels?.count ?? 0 == 0) {
                    self.randomizedPostsData = PostsModel(postModels: postList.shuffled())
                }
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
    
    func fetchFollowingFeed(isAdmin: Bool, currentUserId: String) {
        if (followingUsersListener  != nil && followingPostsListener != nil) {
            return
        }
        
        let fetchFollowingQuery = db.collection("followers")
            .whereField("users", arrayContains: currentUserId)
            .order(by: "mostRecentPostTimestamp", descending: true)
            .limit(to: 10)
        
        followingUsersListener = fetchFollowingQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var followingList = [FollowerModel]()
            followingList = documents.compactMap { querySnapshot -> FollowerModel? in
                return try? querySnapshot.data(as: FollowerModel.self)
            }
            let followingUserIds = followingList.compactMap { followerModel -> String in
                followerModel.id ?? "noId"
            }
            if (!followingUserIds.isEmpty) {
                self.fetchFollowingPosts(isAdmin: isAdmin, followingUserIds: followingUserIds)
            }
        }
    }
    
    private func fetchFollowingPosts(isAdmin: Bool, followingUserIds: [String]) {
        if (followingPostsListener != nil) {
            followingPostsListener?.remove()
        }
        
        var fetchPostQuery: Query
        if (isAdmin) {
            fetchPostQuery = db.collection("posts")
                .whereField("author.userId", in: followingUserIds)
                .order(by: "createdAt", descending: true)
        } else {
            fetchPostQuery = db.collection("posts")
                .whereField("groupId", isEqualTo: Constants.FITGroupId)
                .whereField("author.userId", in: followingUserIds)
                .order(by: "createdAt", descending: true)
        }
        
        followingPostsListener = fetchPostQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var postList = [PostModel]()
            postList = documents.compactMap { querySnapshot -> PostModel? in
                return try? querySnapshot.data(as: PostModel.self)
            }
            DispatchQueue.main.async {
                self.followingPostsData = PostsModel(postModels: postList)
            }
        }
    }
    
    func refreshRandomFeed() {
        DispatchQueue.main.async {
            self.randomizedPostsData.postModels = self.postsData.postModels?.shuffled()
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
    
    func fetchPostLikesForUser(with userId: String) {
        if (userId == "noId") {
            return
        }
        likesListener = db.collectionGroup("likes").whereField("author.userId", isEqualTo: userId).order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var listOfLikes = [String]()
            for document in documents {
                if let postId = document.reference.parent.parent?.documentID {
                    listOfLikes.append(postId)
                }
            }
            DispatchQueue.main.async {
                self.postsUserHasLikedList = listOfLikes
            }
        }
    }
    
    func hasUserLikedPost(postId: String) -> Bool {
        return postsUserHasLikedList.contains(postId)
    }
 
    func likePost(postModel: PostModel, likeModel: LikeModel) {
        if let postId = postModel.id {
            if let userId = likeModel.author.userId {
                let likeDocument = self.db.collection("posts").document(postId).collection("likes").document(userId)
                let postDocument = self.db.collection("posts").document(postId)
                do {
                    let batch = db.batch()
                    try batch.setData(from: likeModel, forDocument: likeDocument, merge: true)
                    batch.updateData(["likesCount": FieldValue.increment(Int64(1))], forDocument: postDocument)
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing likePost batch \(err)")
                        } else {
                            DispatchQueue.main.async {
                                self.postsUserHasLikedList.append(postId)
                            }
                            print("Batch write for likePost succeeded.")
                        }
                    }
                }
                catch {
                    print (error)
                }
            }
        }
    }
        
    func unlikePost(postModel: PostModel, userId: String?) {
        if let userId = userId {
            if let postId = postModel.id {
                let likeDocument = self.db.collection("posts").document(postId).collection("likes").document(userId)
                let postDocument = self.db.collection("posts").document(postId)
                let batch = db.batch()
                batch.deleteDocument(likeDocument)
                batch.updateData(["likesCount": FieldValue.increment(Int64(-1))], forDocument: postDocument)
                batch.commit() { err in
                    if let err = err {
                        print("Error writing unlikePost batch \(err)")
                    } else {
                        DispatchQueue.main.async {
                            self.postsUserHasLikedList.removeAll{ $0 == postId }
                        }
                        print("Batch write for unlikePost succeeded.")
                    }
                }
            }
        }
    }
}
