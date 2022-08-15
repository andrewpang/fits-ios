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
import Cloudinary

class PostViewModel: ObservableObject {
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
            } else if (postType == "intro") {
                return Constants.introRecommendedDetails
            } else {
                return ""
            }
        }
    }
    
    private var db = Firestore.firestore()
    
    func submitPost(mediaItems: PickedMediaItems, postAuthorMap: PostAuthorMap, groupId: String?, completion: @escaping () -> Void) {
        self.isSubmitting = true
        var imagesDownloaded = 0
        var postImageUrls = Array(repeating: "", count: mediaItems.items.count)
        for (index, image) in mediaItems.items.enumerated() {
            guard var imageData = image.photo?.jpegData(compressionQuality: 1.0) else { return }
            if (imageData.count > 300 * 1024) {
                if (imageData.count > 1024 * 1024) {// 1m and above
                    imageData = image.photo?.jpegData(compressionQuality: 0.3) ?? imageData
                } else if (imageData.count > 512 * 1024) {//0.5M-1M
                    imageData = image.photo?.jpegData(compressionQuality: 0.5) ?? imageData
                } else if (imageData.count > 300 * 1024) {//0.25M-0.5M
                    imageData = image.photo?.jpegData(compressionQuality: 0.9) ?? imageData
                }
            }
            
            let config = CLDConfiguration(cloudName: "fitsatfit", secure: true)
            let cloudinary = CLDCloudinary(configuration: config)
            
            let uploadRequestParams = CLDUploadRequestParams().setFolder("postImages/\(Auth.auth().currentUser?.uid ?? "noUserId")")
            
            let request = cloudinary.createUploader().upload(
                data: imageData, uploadPreset: "fsthtouv", params: uploadRequestParams) { progress in
                  // Handle progress
            } completionHandler: { result, error in
                  // Handle result
                guard let downloadURL = result?.secureUrl else {
                    // Uh-oh, an error occurred!
                    print(error)
                    return
                }
                postImageUrls[index] = downloadURL
                imagesDownloaded += 1
                if (imagesDownloaded == mediaItems.items.count) {
//                    TODO(REE-158): remove imageUrl once no one is on 1.1 build 8 or before
                    let postModel = PostModel(author: postAuthorMap, imageUrl: postImageUrls[0], imageUrls: postImageUrls, title: self.postTitle, body: self.postBody,  likesCount: 0, tags: self.postTags, groupId: groupId)
                    self.uploadPostModel(postModel: postModel, completion: completion)
                }
            }
            
//            let storage = Storage.storage()
//            let imagesRef = storage.reference().child("postImages").child(Auth.auth().currentUser?.uid ?? "noUserId")
//
//            let imageRef = imagesRef.child(image.id)
//
//            let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
//                // You can also access to download URL after upload.
//                imageRef.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        // Uh-oh, an error occurred!
//                        print(error)
//                        return
//                    }
//                    postImageUrls[index] = downloadURL.absoluteString
//                    imagesDownloaded += 1
//                    if (imagesDownloaded == mediaItems.items.count) {
////                    TODO(REE-158): remove imageUrl once no one is on 1.1 build 8 or before
//                        let postModel = PostModel(author: postAuthorMap, imageUrl: postImageUrls[0], imageUrls: postImageUrls, title: self.postTitle, body: self.postBody,  likesCount: 0, tags: self.postTags, groupId: groupId)
//                        self.uploadPostModel(postModel: postModel, completion: completion)
//                    }
//                }
//            }
        }
    }
    
    func uploadPostModel(postModel: PostModel, completion: @escaping () -> Void) {
        let postsCollection = self.db.collection("posts")
        do {
            let _ = try postsCollection.addDocument(from: postModel) { error in
                if let error = error {
                    print("Error adding post: \(error)")
                } else {
                    print("Uploaded Post Model")
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
