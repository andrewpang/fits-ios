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
    
    var bookmarksListener: ListenerRegistration?
    var postsListener: ListenerRegistration?
    
    private var db = Firestore.firestore()
    
    init(bookmarkBoardModel: BookmarkBoardModel) {
        self.bookmarkBoardModel = bookmarkBoardModel
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
    
    func fetchPostsForBookmarkBoard() {
        if (bookmarksListener != nil) {
            return
        }

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
    }
    
    func fetchPostModels() {
        if (postsListener != nil) {
            return
        }
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
}
