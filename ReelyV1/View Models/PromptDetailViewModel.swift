//
//  PromptDetailViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import Foundation
import Firebase

class PromptDetailViewModel: ObservableObject {
    
    @Published var detailViewIsActive = false
    
    @Published var promptModel: PromptModel
    @Published var postsData = PostsModel()
    @Published var postsUserHasLikedList = [String]()
    var promptPostModel: PromptPostModel?
    
    private var db = Firestore.firestore()
    
    var promptPostsListener: ListenerRegistration?
    
    init(promptModel: PromptModel, promptPostModel: PromptPostModel?) {
        self.promptModel = promptModel
        self.promptPostModel = promptPostModel
    }
    
    func fetchPostsForPrompt() {
        if (promptPostsListener != nil) {
            return
        }
        
        var fetchPromptPostsQuery: Query
        fetchPromptPostsQuery = db.collection("posts")
            .whereField("prompt.promptId", isEqualTo: promptModel.id)
            .order(by: "createdAt", descending: true)
        
        promptPostsListener = fetchPromptPostsQuery.addSnapshotListener { (querySnapshot, error) in
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
    
    func fetchPostLikesForUser(with userId: String) {
        if (userId == "noId") {
            return
        }
        db.collectionGroup("likes").whereField("author.userId", isEqualTo: userId).order(by: "createdAt", descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting user likes: \(error)")
            } else {
                var listOfLikes = [String]()
                for document in snapshot!.documents {
                    if let postId = document.reference.parent.parent?.documentID {
                        listOfLikes.append(postId)
                    }
                }
                DispatchQueue.main.async {
                    self.postsUserHasLikedList = listOfLikes
                }
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
    
    func userHasPostedInLastDay() -> Bool {
        if let promptPostModel = promptPostModel {
            if let postedTimestamps = promptPostModel.postedTimestamps {
                for timestamp in postedTimestamps {
                    if (isSameDay(date1: timestamp.dateValue(), date2: Timestamp.init().dateValue()) && isWithin12Hours(date1: timestamp.dateValue(), date2: Timestamp.init().dateValue())) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isWithin12Hours(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.hour], from: date1, to: date2)
        if let diffHour = diff.hour, diffHour < 12 {
            return true
        } else {
            return false
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func resetData() {
        DispatchQueue.main.async {
            self.promptModel = PromptModel(title: "")
            self.postsData = PostsModel()
        }
    }
    
    func removeListeners() {
        promptPostsListener?.remove()
    }
}

