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
                        print("Error adding comment: \(error)")
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
}
    
