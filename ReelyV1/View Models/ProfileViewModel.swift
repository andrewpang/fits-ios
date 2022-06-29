//
//  ProfileViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 6/28/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    
    @Published var imageUrl: String = "https://www.nacdnet.org/wp-content/uploads/2016/06/person-placeholder.jpg"
    
    @Published var name: String = ""
    @Published var bio: String = ""
    @Published var showSheet: Bool = false
    @Published var image: UIImage? = nil
    
    private var db = Firestore.firestore()
    
    func addProfilePhoto(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilePhotos").child(Auth.auth().currentUser?.uid ?? "noUserId")
        
        let imageRef = imagesRef.child(UUID().uuidString)
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.imageUrl = downloadURL.absoluteString
            }
        }
    }
    
    //TODO: Change to ProfileModel
//    func uploadPostModel(postModel: PostModel) {
//        let postsCollection = self.db.collection("posts")
//        let postDocument = postsCollection.document(postModel.id)
//        postDocument.setData([
//            "author": postModel.author.trimmingCharacters(in: .whitespacesAndNewlines),
//            "imageUrl": postModel.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines),
//            "likes": postModel.likes,
//            "timestamp": Timestamp(),
//            "brandName": postModel.brandName.trimmingCharacters(in: .whitespacesAndNewlines),
//            "productName": postModel.productName.trimmingCharacters(in: .whitespacesAndNewlines),
//            "price": postModel.price.trimmingCharacters(in: .whitespacesAndNewlines),
//            "body": postModel.body
//        ], merge: true) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully updated!")
//                self.isLoading = false
//                DispatchQueue.main.async {
//                    self.tabSelection = 1
//                    self.showYPImagePickerView = true
//                    self.postBrandName = ""
//                    self.postProductName = ""
//                    self.postPrice = ""
//                    self.postBody = ""
//                }
//            }
//        }
    
}
