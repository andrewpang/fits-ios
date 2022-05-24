//
//  HomeViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    
    @Published var postsData = PostsModel()
    
    private var db = Firestore.firestore()
    
    func fetchPosts() {
        DispatchQueue.main.async {
            let postsCollection = self.db.collection("posts")
            postsCollection.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var postList = [PostModel]()
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if let postModel = PostModel(document.data()) {
                            postList.append(postModel)
                        }
                    }
                    self.postsData = PostsModel(postModels: postList)
                }
            }
        }
    }
}
