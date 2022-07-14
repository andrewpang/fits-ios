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
            db.collection("posts").document(postId).collection("comments").order(by: "createdAt", descending: false).addSnapshotListener { (querySnapshot, error) in
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
                do {
                    let _ = try likeDocument.setData(from: likeModel) { error in
                        if let error = error {
                            print("Error adding LikeModel: \(error)")
                        } else {
                            self.isLiked = true
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
                likeDocument.delete() { err in
                    if let err = err {
                        print("Error removing like document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.isLiked = false
                    }
                }
            }
        }
    }
}
    
