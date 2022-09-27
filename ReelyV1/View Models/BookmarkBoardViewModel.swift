//
//  BookmarkBoardViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/26/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class BookmarkBoardViewModel: ObservableObject {
    
    @Published var bookmarkBoardModel: BookmarkBoardModel
    @Published var bookmarksList = [BookmarkModel]()
    @Published var postIdsList = [String]()
    @Published var postsData = PostsModel(postModels: [PostModel]())
    @Published var creatorName = ""
    @Published var shouldScrollToTop = false
    @Published var shouldPopToRootViewIfFalse = false
    @Published var postsUserHasLikedList = [String]()
    
    var bookmarksListener: ListenerRegistration?
    
    private var db = Firestore.firestore()
    
    init(bookmarkBoardModel: BookmarkBoardModel) {
        self.bookmarkBoardModel = bookmarkBoardModel
    }
    
    init() {
        self.bookmarkBoardModel = BookmarkBoardModel()
    }
    
    func fetchCreatorName() {
        if let creatorId = bookmarkBoardModel.creatorId {
            db.collection("users").document(creatorId).getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let data = document.data() else {
                       print("Document data was empty.")
                       return
                    }
                    print("Current data: \(data)")
                    guard let userData = try? document.data(as: UserModel.self) else {
                        print("Couldn't parse user data to UserModel")
                        return
                    }
                    DispatchQueue.main.async {
                        self.creatorName = userData.displayName ?? ""
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func fetchPostsForBookmarkBoard(with userId: String) {
        if (bookmarksListener != nil) {
            bookmarksListener?.remove() //Refetch
        }
        
        if let bookmarkBoardTitle = bookmarkBoardModel.title, !bookmarkBoardTitle.isEmpty {
            bookmarksListener = db.collection("bookmarks")
                .whereField("boardIds", arrayContains: bookmarkBoardModel.id ?? "noId")
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }

                    var bookmarksList = [BookmarkModel]()
                    bookmarksList = documents.compactMap { querySnapshot -> BookmarkModel? in
                        return try? querySnapshot.data(as: BookmarkModel.self)
                    }
                    DispatchQueue.main.async {
                        self.bookmarksList = bookmarksList
                        self.postIdsList = bookmarksList.compactMap { bookmarkModel -> String in
                            return bookmarkModel.postId ?? "noId"
                        }
                        self.fetchPostModels()
                    }
                }
        } else {
            bookmarksListener = db.collection("bookmarks")
                .whereField("bookmarkerId", isEqualTo: userId)
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }

                    var bookmarksList = [BookmarkModel]()
                    bookmarksList = documents.compactMap { querySnapshot -> BookmarkModel? in
                        return try? querySnapshot.data(as: BookmarkModel.self)
                    }
                    DispatchQueue.main.async {
                        self.bookmarksList = bookmarksList
                        self.postIdsList = bookmarksList.compactMap { bookmarkModel -> String in
                            return bookmarkModel.postId ?? "noId"
                        }
                        self.fetchPostModels()
                    }
                }
        }
    }
    
    func fetchPostModels() {
        var postsDownloaded = 0
        var postsList: [Any] = Array(repeating: "", count: postIdsList.count)
        
        for (index, postId) in postIdsList.enumerated() {
            db.collection("posts").document(postId).getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let data = document.data() else {
                       print("Document data was empty.")
                       return
                    }
                    print("Current data: \(data)")
                    guard let postData = try? document.data(as: PostModel.self) else {
                        print("Couldn't parse user data to PostModel")
                        return
                    }
                    postsList[index] = postData
                    postsDownloaded += 1
                    if (postsDownloaded == self.postIdsList.count) {
                        DispatchQueue.main.async {
                            self.postsData = PostsModel(postModels: postsList as? [PostModel])
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func deleteBookmarkBoard() {
        if let bookmarkBoardId = bookmarkBoardModel.id {
            let bookmarkBoardDocument = self.db.collection("bookmarkBoards").document(bookmarkBoardId)
            bookmarkBoardDocument.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    for bookmark in self.bookmarksList {
                        if let bookmarkerId = bookmark.bookmarkerId {
                            if let postId = bookmark.postId {
                                self.removeBookmarkFromBoard(postId: postId, bookmarkerId: bookmarkerId, boardId: bookmarkBoardId)
                            }
                        }
                    }
                }
            }
        }
    }
            
    func removeBookmarkFromBoard(postId: String, bookmarkerId: String, boardId: String) {
        let bookmarksCollection = self.db.collection("bookmarks")
        let documentId = "\(bookmarkerId)_\(postId)"
        let bookmarkDocument = bookmarksCollection.document(documentId)
        bookmarkDocument.setData([
            "boardIds": FieldValue.arrayRemove([boardId])
        ], merge: true){ error in
            if let error = error {
                print("Error removing boardIds from bookmarkModel: \(error)")
            } else {
                print("Removed boardId from bookmarkModel")
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
}
