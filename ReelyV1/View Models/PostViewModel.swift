//
//  PostViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/2/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import SwiftUI

class PostViewModel: ObservableObject {
//    enum PostType: String {
//        case OOTD = "ootd"
//    }
    
    @Published var postsData = PostsModel()
    @Published var isSubmitting = false
    @Published var shouldPopToRootViewIfFalse = false
    
    @Published var postTitle: String = ""
    @Published var postBody: String = ""
    @Published var postTags: [String]?
    @Published var postImage: UIImage?
    
    @Published var postType: String = "ootd"
    var recommendedDetails: String {
        get {
            if (postType == "ootd") {
                return Constants.ootdRecommendedDetails
            } else if (postType == "productReview") {
                return Constants.productReviewRecommendedDetails
            } else {
                return ""
            }
        }
    }
    
    private var db = Firestore.firestore()
    
    func submitPost(postAuthorMap: PostAuthorMap, groupId: String?, completion: @escaping () -> Void) {
        self.isSubmitting = true
        guard let imageData = postImage?.jpegData(compressionQuality: 0.5) else { return }
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("postImages").child(Auth.auth().currentUser?.uid ?? "noUserId")
        
        let imageRef = imagesRef.child(UUID().uuidString)
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                let postModel = PostModel(author: postAuthorMap, imageUrl: downloadURL.absoluteString, title: self.postTitle, body: self.postBody,  likes: 0, tags: self.postTags, groupId: groupId)
                self.uploadPostModel(postModel: postModel, completion: completion)
            }
        }
    }
    
    func uploadPostModel(postModel: PostModel, completion: @escaping () -> Void) {
        let postsCollection = self.db.collection("posts")
        do {
            let _ = try postsCollection.addDocument(from: postModel) { error in
                if let error = error {
                    print("Error adding post: \(error)")
                } else {
                    self.isSubmitting = false
                    self.resetData()
                    completion()
                }
            }
        }
        catch {
            print (error)
        }
    }
    
    func resetData() {
        postTitle = ""
        postBody = ""
        postTags = nil
        postImage = nil
    }
}
