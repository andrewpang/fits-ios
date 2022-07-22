//
//  MyProfileViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 7/21/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class MyProfileViewModel: ObservableObject {
    
    @Published var postsData = PostsModel()
    
    var postsListener: ListenerRegistration?
    
    private var db = Firestore.firestore()
    
    func fetchPosts() {
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
}
