//
//  HomeViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel: ObservableObject {
    
    @Published var postsData = PostsModel()
    
    private var db = Firestore.firestore()
    
    func fetchPosts() {
        db.collection("posts").order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var postList = [PostModel]()
            postList = querySnapshot!.documents.compactMap { querySnapshot -> PostModel? in
                return try? querySnapshot.data(as: PostModel.self)
            }
            DispatchQueue.main.async {
                if (self.postsData.postModels != nil) {
                    self.postsData.postModels = postList
                } else {
                    self.postsData = PostsModel(postModels: postList)
                }
            }
        }
    }
}
