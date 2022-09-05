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
    @Published var isSubmitting = false
    
    private var db = Firestore.firestore()
    
    var commentsListener: ListenerRegistration?
    var likesListener: ListenerRegistration?
    var commentsLikesListeners: [ListenerRegistration]?
    
    @Published var commentIdToCommentLikesDictionary: [String: CommentLikesModel] = [:]
    
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
                    self.fetchCommentLikes()
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
        fetchUserHasLikedPost(userId: userId)
//        fetchRecentLikers(userId: userId)
    }
    
    func fetchUserHasLikedPost(userId: String?) {
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
        if let commentsLikesListeners = commentsLikesListeners {
            for listener in commentsLikesListeners {
                listener.remove()
            }
        }
    }
    
    func deletePost() {
        if let postId = postModel.id {
            let postDocument = self.db.collection("posts").document(postId)
            postDocument.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func editPost(title: String, body: String) {
        self.isSubmitting = true
        if let postId = postModel.id {
            let postDocument = self.db.collection("posts").document(postId)
            postDocument.updateData([
                "title": title,
                "body": body,
                "lastUpdated": FieldValue.serverTimestamp(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    self.isSubmitting = false
                } else {
                    print("Document successfully updated")
                    self.isSubmitting = false
                    //Passing PostModel in without listener, so easier to just set on client for now
                    self.postModel.title = title
                    self.postModel.body = body
                }
            }
        }
    }
    
    func likeComment(commentLikeModel: CommentLikeModel) {
        if let postId = postModel.id {
            if let userId = commentLikeModel.author.userId {
                if let commentId = commentLikeModel.commentId {
                    let commentDocument = self.db.collection("posts").document(postId).collection("comments").document(commentId)
                    let commentLikeDocument = commentDocument.collection("commentLikes").document(userId)
                    do {
                        let batch = db.batch()
                        try batch.setData(from: commentLikeModel, forDocument: commentLikeDocument, merge: true)
                        batch.updateData(["commentLikesCount": FieldValue.increment(Int64(1))], forDocument: commentDocument)
                        batch.commit() { err in
                            if let err = err {
                                print("Error writing likeComment batch \(err)")
                            } else {
                                print("Batch write for likeComment succeeded.")
                            }
                        }
                    }
                    catch {
                        print (error)
                    }
                }
            }
        }
    }
    
    func unlikeComment(commentId: String, userId: String?) {
        if let userId = userId {
            if let postId = postModel.id {
                let commentDocument = self.db.collection("posts").document(postId).collection("comments").document(commentId)
                let commentLikeDocument = commentDocument.collection("commentLikes").document(userId)
                let batch = db.batch()
                batch.deleteDocument(commentLikeDocument)
                batch.updateData(["likesCount": FieldValue.increment(Int64(-1))], forDocument: commentDocument)
                batch.commit() { err in
                    if let err = err {
                        print("Error writing unlikeComment batch \(err)")
                    } else {
                        print("Batch write for unlikeComment succeeded.")
                    }
                }
            }
        }
    }
    
    func fetchCommentLikes() {
        if let postModelId = postModel.id {
            if let commentModels = commentsData.commentModels {
                for comment in commentModels {
                    if let commentId = comment.id {
                        let commentLikesRef = db.collection("posts").document(postModelId).collection("comments").document(commentId).collection("commentLikes")
                        
                        let commentLikesListener = commentLikesRef.addSnapshotListener { querySnapshot, error in
                            guard let documents = querySnapshot?.documents else {
                                print("Error fetching documents: \(error!)")
                                return
                            }
                            self.commentIdToCommentLikesDictionary.removeAll()
                            
                            var commentLikes = [CommentLikeModel]()
                            commentLikes = documents.compactMap { querySnapshot -> CommentLikeModel? in
                                return try? querySnapshot.data(as: CommentLikeModel.self)
                            }
                            DispatchQueue.main.async {
                                self.commentIdToCommentLikesDictionary[commentId] = CommentLikesModel(commentLikeModels: commentLikes)
                            }
                        }
                        commentsLikesListeners?.append(commentLikesListener)
                    }
                }
            }
        }
    }
}
