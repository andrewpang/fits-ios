//
//  PostDetailViewModel.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class PostDetailViewModel: ObservableObject {
    
    @Published var postModel: PostModel
    @Published var commentsData = CommentsModel()
    @Published var commentText = ""
    @Published var isLiked = false
    @Published var likeText = ""
    
    private var db = Firestore.firestore()
    
    var commentsListener: ListenerRegistration?
    var likesListener: ListenerRegistration?
    
    init(postModel: PostModel) {
        self.postModel = postModel
    }
    
    func postComment(commentModel: CommentModel) {
        if let postId = postModel.id {
            let commentsCollection = self.db.collection("posts").document(postId).collection("comments")
            do {
                let _ = try commentsCollection.addDocument(from: commentModel) { error in
                    if let error = error {
                        print("Error adding CommentModel: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.commentText = ""
                        }
                    }
                }
            }
            catch {
                print (error)
            }
        }
    }
    
    func fetchComments() {
        if let postId = postModel.id {
            commentsListener = db.collection("posts").document(postId).collection("comments").order(by: "createdAt", descending: false).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }

                var commentsList = [CommentModel]()
                commentsList = documents.compactMap { querySnapshot -> CommentModel? in
                    return try? querySnapshot.data(as: CommentModel.self)
                }
                DispatchQueue.main.async {
                    self.commentsData = CommentsModel(commentModels: commentsList)
                }
            }
        }
    }
    
    func likePost(likeModel: LikeModel) {
        postModel.incrementLikesCount(number: +1)
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
    
    func unlikePost(userId: String?) {
        postModel.incrementLikesCount(number: -1)
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
                        print("Batch write for unlikePost succeeded.")
                    }
                }
            }
        }
    }
    
    func fetchLikes(userId: String?) {
        fetchUserHasLikePost(userId: userId)
//        fetchRecentLikers(userId: userId)
    }
    
    func fetchUserHasLikePost(userId: String?) {
        if let userId = userId {
            if let postId = postModel.id {
                let likeDocument = db.collection("posts").document(postId).collection("likes").document(userId)
                likesListener = likeDocument.addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        DispatchQueue.main.async {
                            self.isLiked = false
                        }
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        DispatchQueue.main.async {
                            self.isLiked = false
                        }
                        return
                    }
                    print("Current data: \(data)")
                    DispatchQueue.main.async {
                        self.isLiked = true
                    }
                }
            }
        }
    }
    
    func fetchRecentLikers(userId: String?) {
        if let postId = postModel.id {
            db.collection("posts").document(postId).collection("likes").order(by: "createdAt", descending: true).limit(toLast: 3).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting likers: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    var recentLikers = [LikeModel]()
                    recentLikers = querySnapshot!.documents.compactMap { querySnapshot -> LikeModel? in
                        return try? querySnapshot.data(as: LikeModel.self)
                    }.filter({ likeModel in
                        likeModel.author.userId != userId
                    })
                    
                    var likeString: String
                    if (recentLikers.isEmpty) {
                        likeString = "Liked by others"
                    } else if (recentLikers.count == 1) {
                        likeString = "Liked by \(String(recentLikers[0].author.displayName ?? "")) and others"
                    } else {
                        likeString = "Liked by \(String(recentLikers[0].author.displayName ?? "")), \(String(describing: recentLikers[1].author.displayName ?? "")) and others"
                    }
                    
                    DispatchQueue.main.async {
                        self.likeText = likeString
                    }
                }
            }
        }
    }
    
    func removeListeners() {
        commentsListener?.remove()
        likesListener?.remove()
    }
}
    
