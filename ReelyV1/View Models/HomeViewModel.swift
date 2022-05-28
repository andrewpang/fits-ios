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
    @Published var isLoading = false
    
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
    
    func addPost(image: UIImage, author: String, body: String, title: String, likes: Int) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("images")
        
        let imageRef = imagesRef.child(UUID().uuidString)
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                let postModel = PostModel(author: author, body: body, imageUrl: downloadURL.absoluteString, title: title, likes: 0)
                self.uploadPostModel(postModel: postModel)
            }
        }
    }
    
    func uploadPostModel(postModel: PostModel) {
        let postsCollection = self.db.collection("posts")
        let postDocument = postsCollection.document(postModel.id)
        postDocument.setData([
            "author": postModel.author,
            "title": postModel.title,
            "imageUrl": postModel.imageUrl,
            "body": postModel.body,
            "likes": postModel.likes,
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
}
