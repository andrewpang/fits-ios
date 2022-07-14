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
                        self.commentText = ""
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
                commentsList = querySnapshot!.documents.compactMap { querySnapshot -> CommentModel? in
                    return try? querySnapshot.data(as: CommentModel.self)
                }
                DispatchQueue.main.async {
                    self.commentsData = CommentsModel(commentModels: commentsList)
                }
            }
        }
    }
    
    func likePost(likeModel: LikeModel) {
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
    
    func fetchLikeModel(userId: String?) {
        if let userId = userId {
            if let postId = postModel.id {
                let likeDocument = db.collection("posts").document(postId).collection("likes").document(userId)
                likesListener = likeDocument.addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        self.isLiked = false
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        self.isLiked = false
                        return
                    }
                    print("Current data: \(data)")
                    self.isLiked = true
                  }
            }
        }
    }
    
    func removeListeners() {
        commentsListener?.remove()
        likesListener?.remove()
    }
}
    
