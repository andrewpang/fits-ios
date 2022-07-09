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
import SwiftUI
import Amplitude

class ProfileViewModel: ObservableObject {
    
    @Published var imageUrl: String = ""
    @Published var displayName: String = ""
    @Published var bio: String = ""
    @Published var showPhotoSelectorSheet: Bool = false
    @Published var image: UIImage? = nil
    @Published var phoneNumber: String = ""
    
    @Published var major: String = ""
    @Published var graduationYear: Int = -1
    
    //HARDCODED FOR FIT
    let school: String = "Fashion Institute of Technology"
    let FITGroupId = "caSMxvTTCAZtARFCH6xK"
    
    private var db = Firestore.firestore()
    
    func uploadProfilePhotoAndModel() {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            self.uploadNewUserModel()
            return
        }
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
                self.uploadNewUserModel()
            }
        }
    }
    
    func uploadNewUserModel() {
        if let uid = Auth.auth().currentUser?.uid {
            Amplitude.instance().setUserId(uid)
            let userModel = UserModel(
                id: uid,
                displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
                bio: bio.isEmpty ? nil : bio.trimmingCharacters(in: .whitespacesAndNewlines),
                profilePicImageUrl: imageUrl.isEmpty ? nil : imageUrl,
                groups: [FITGroupId],
                phoneNumber: phoneNumber,
                school: school.isEmpty ? nil : school.trimmingCharacters(in: .whitespacesAndNewlines),
                major: major.isEmpty ? nil : major.trimmingCharacters(in: .whitespacesAndNewlines),
                graduationYear: graduationYear
            )
            let usersCollection = self.db.collection("users")
            do {
                let _ = try usersCollection.document(uid).setData(from: userModel, merge: false) { error in
                    if let error = error {
                        print("Error adding post: \(error)")
                    } else {
                        print("Added userModel")
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
}
