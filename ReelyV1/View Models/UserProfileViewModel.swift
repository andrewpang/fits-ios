//
//  UserPostViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 7/24/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Published var userModel: UserModel? = nil
    @Published var postsData = PostsModel()
    
    var profileListener: ListenerRegistration?
    var postsListener: ListenerRegistration?
    
    private var db = Firestore.firestore()
    
    func fetchUserModel(for userId: String) {
        if let _ = Auth.auth().currentUser?.uid {
            if (profileListener == nil) {
                profileListener = db.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    print("Current data: \(data)")
                    guard let userData = try? document.data(as: UserModel.self) else {
                        print("Couldn't parse user data to UserModel")
                        return
                    }
                    self.userModel = userData
                }
            }
        }
    }
    
    func fetchCurrentUserPosts() {
        if (postsListener != nil) {
            return
        }
        if let uid = Auth.auth().currentUser?.uid {
            postsListener = db.collection("posts")
                .whereField("author.userId", isEqualTo: uid)
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
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
    }
    
    func fetchPostsForUser(for userId: String) {
        if (postsListener != nil) {
            return
        }
        if let _ = Auth.auth().currentUser?.uid {
            postsListener = db.collection("posts")
                .whereField("author.userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
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
    }
    
    func removeListeners() {
        profileListener?.remove()
        postsListener?.remove()
    }
}
