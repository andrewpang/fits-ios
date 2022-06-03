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
    @Published var isPostSubmitted = false
    @Published var tabSelection = 1
    @Published var showYPImagePickerView = true
    
    @Published var postTitle: String = ""
    @Published var postBody: String = ""
    
    @Published var postBrandName: String = ""
    @Published var postProductName: String = ""
    @Published var postPrice: String = ""
    @Published var postLoveAboutIt: String = ""
    @Published var postDislikeAbout: String = ""
    @Published var postWhoFor: String = ""
    @Published var postWhoNotFor: String = ""
    
    private var db = Firestore.firestore()
    
    func fetchPosts() {
        DispatchQueue.main.async {
            let postsCollection = self.db.collection("posts")
            postsCollection.order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
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
    
    func addPost(image: UIImage, author: String, likes: Int, brandName: String, productName: String, price: String, body: String) {
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
                let postModel = PostModel(author: author, imageUrl: downloadURL.absoluteString, likes: 0, brandName: brandName, productName: productName, price: price, body: body)
                self.uploadPostModel(postModel: postModel)
            }
        }
    }
    
    func uploadPostModel(postModel: PostModel) {
        let postsCollection = self.db.collection("posts")
        let postDocument = postsCollection.document(postModel.id)
        postDocument.setData([
            "author": postModel.author.trimmingCharacters(in: .whitespacesAndNewlines),
            "imageUrl": postModel.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines),
            "likes": postModel.likes,
            "timestamp": Timestamp(),
            "brandName": postModel.brandName.trimmingCharacters(in: .whitespacesAndNewlines),
            "productName": postModel.productName.trimmingCharacters(in: .whitespacesAndNewlines),
            "price": postModel.price.trimmingCharacters(in: .whitespacesAndNewlines),
            "body": postModel.body
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully updated!")
                self.isLoading = false
                DispatchQueue.main.async {
                    self.tabSelection = 1
                    self.showYPImagePickerView = true
                    self.postBrandName = ""
                    self.postProductName = ""
                    self.postPrice = ""
                    self.postBody = ""
                }
            }
        }
    }
}
