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
    
    @Published var displayName: String = ""
    @Published var bio: String = ""
    @Published var showSheet: Bool = false
    @Published var image: UIImage? = nil
    
    @Published var major: String = ""
    @Published var graduationYear: Int = 2022
    
    private var db = Firestore.firestore()
    
    func uploadProfilePhotoAndModel() {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
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
                self.uploadProfileModel()
            }
        }
    }
    
    func uploadProfileModel() {
        if let uid = Auth.auth().currentUser?.uid {
            let usersCollection = self.db.collection("users")
            let userDocument = usersCollection.document(uid)
            userDocument.setData([
                "displayName": self.displayName.trimmingCharacters(in: .whitespacesAndNewlines),
                "school": "FIT",
                "major": self.major.trimmingCharacters(in: .whitespacesAndNewlines),
                "graduationYear": self.graduationYear,
                "bio": self.bio.trimmingCharacters(in: .whitespacesAndNewlines),
                "profilePicImageUrl": self.imageUrl.trimmingCharacters(in: .whitespacesAndNewlines),
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
        
    }
    
}
