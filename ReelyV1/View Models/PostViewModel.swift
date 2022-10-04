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
    @Published var postRating: Int?
    
    @Published var postType: String = "ootd"
    var recommendedDetails: String {
        get {
            if (postType == "ootd") {
                return Constants.ootdRecommendedDetails
            } else if (postType == "productreview") {
                return Constants.productReviewRecommendedDetails
            } else if (postType == "intro") {
                return Constants.introRecommendedDetails
            } else {
                return Constants.ootdRecommendedDetails
            }
        }
    }
    
    private var db = Firestore.firestore()
    
    func submitPost(mediaItems: PickedMediaItems, postAuthorMap: PostAuthorMap, groupId: String?, prompt: PostPromptMap?, completion: @escaping () -> Void) {
        self.isSubmitting = true
        var imagesDownloaded = 0
        var postImageUrls = Array(repeating: "", count: mediaItems.items.count)
        var thumbnailHeight: Double = 0.0
        var thumbnailWidth: Double = 0.0
        for (index, image) in mediaItems.items.enumerated() {
            if (index == 0) {
                thumbnailHeight = Double(image.photo?.size.height ?? 0.0)
                thumbnailWidth = Double(image.photo?.size.width ?? 0.0)
            }
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
                    var postModel: PostModel
                    if let postRating = self.postRating {
                        postModel = PostModel(author: postAuthorMap, imageUrls: postImageUrls, title: self.postTitle, body: self.postBody,  likesCount: 0, tags: self.postTags, groupId: groupId, thumbnailHeight: thumbnailHeight, thumbnailWidth: thumbnailWidth, prompt: prompt, reviewRating: Double(postRating))
                    } else {
                        postModel = PostModel(author: postAuthorMap, imageUrls: postImageUrls, title: self.postTitle, body: self.postBody,  likesCount: 0, tags: self.postTags, groupId: groupId, thumbnailHeight: thumbnailHeight, thumbnailWidth: thumbnailWidth, prompt: prompt)
                    }
                    self.uploadPostModel(postModel: postModel, completion: completion)
                    if let prompt = prompt {
                        self.uploadPromptPostModel(userId: postAuthorMap.userId, promptId: prompt.promptId)
                        self.uploadPromptPostImageUrl(promptId: prompt.promptId, imageUrl: postImageUrls[0])
                    }
                }
            }
        }
    }
    
    func uploadPostModel(postModel: PostModel, completion: @escaping () -> Void) {
        let postsDocument = self.db.collection("posts").document(postModel.id!)
        let followersDocument = self.db.collection("followers").document(postModel.author.userId ?? "noId")
        do {
            let batch = db.batch()
            batch.setData([
                "mostRecentPostTimestamp": FieldValue.serverTimestamp(),
            ], forDocument: followersDocument, merge: true)
            try batch.setData(from: postModel, forDocument: postsDocument, merge: true)
            batch.commit() { error in
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
    
    func uploadPromptPostModel(userId: String?, promptId: String?) {
        if let userId = userId {
            if let promptId = promptId {
                let promptPostsCollection = self.db.collection("promptPosts")
                let documentId = "\(userId)_\(promptId)"
                
                let docRef = promptPostsCollection.document(documentId)
                docRef.setData([
                    "userId": userId,
                    "promptId": promptId,
                    "postedTimestamps": FieldValue.arrayUnion([Timestamp.init()])
                ], merge: true){ error in
                    if let error = error {
                        print("Error adding promptPost: \(error)")
                    } else {
                        print("Added promptPost")
                    }
                }
            }
        }
    }
    
    func uploadPromptPostImageUrl(promptId: String?, imageUrl: String) {
        if let promptId = promptId {
            self.db.collection("prompts").document(promptId).setData([
                "previewImageUrls": FieldValue.arrayUnion([imageUrl])
            ], merge: true){ error in
                if let error = error {
                    print("Error adding previewImageUrl: \(error)")
                } else {
                    print("Added previewImageUrl")
                }
            }
        }
    }
    
    func resetData() {
        postTitle = ""
        postBody = ""
        postTags = nil
        postImage = nil
    }
}
