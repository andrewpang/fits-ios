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
//    @Published var isLoading = false
//    @Published var isPostSubmitted = false
//    @Published var showYPImagePickerView = true
    
    private var db = Firestore.firestore()
    
//    func fetchPosts() {
//        DispatchQueue.main.async {
//            let postsCollection = self.db.collection("posts")
//            postsCollection.order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    var postList = [PostModel]()
//                    self.postList = querySnapshot!.documents.compactMap { querySnapshot -> PostModel? in
//                        return try? querySnapshot.data(as: PostModel.self)
//                      }
//                    
//                    
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                        if let postModel = PostModel(document.data()) {
//                            postList.append(postModel)
//                        }
//                    }
//                    self.postsData = PostsModel(postModels: postList)
//                }
//            }
//        }
//    }
    
    func fetchPosts() {
        db.collection("posts").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
            print("No documents")
            return
            }
        

        var postList = [PostModel]()
        postList = querySnapshot!.documents.compactMap { querySnapshot -> PostModel? in
            return try? querySnapshot.data(as: PostModel.self)
        }
        DispatchQueue.main.async {
            self.postsData = PostsModel(postModels: postList)
        }
        }
    }
}
