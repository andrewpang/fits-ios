//
//  AuthenticationViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseMessaging
import Amplitude
import SwiftUI
import Mixpanel
import Cloudinary

class AuthenticationViewModel: ObservableObject {
    
    @Published var userModel: UserModel? = nil

    enum SignInState {
        case signedIn
        case signedOut
        case emptyProfile
        case loading
    }

    @Published var state: SignInState = .loading
    
    let db = Firestore.firestore()
    
    private let auth = Auth.auth()
    
    var profileListener: ListenerRegistration?
    
    func checkIfSignedIn() {
        if (Auth.auth().currentUser != nil) {
            getCurrentUserData()
        } else {
            Amplitude.instance().setUserId(nil)
            Mixpanel.mainInstance().reset()
            state = .signedOut
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            Amplitude.instance().setUserId(nil)
            Mixpanel.mainInstance().reset()
            state = .signedOut
            profileListener = nil
        } catch {
        }
    }
    
    func getCurrentUserData() {
        self.saveFCMDeviceToken()
        self.registerUserForTopic(topic: "fit")
        if let uid = Auth.auth().currentUser?.uid {
            Amplitude.instance().setUserId(uid)
            Mixpanel.mainInstance().identify(distinctId: uid)
            if (profileListener == nil) {
                profileListener = db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        self.state = .signedOut
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        self.state = .signedIn
                        return
                    }
                    print("Current data: \(data)")
                    guard let userData = try? document.data(as: UserModel.self) else {
                        print("Couldn't parse user data to UserModel")
                        self.state = .signedOut
                        return
                    }
                    
                    self.userModel = userData
                    self.state = .signedIn
                    Mixpanel.mainInstance().people.set(properties: ["displayName": userData.displayName, "phoneNumber": userData.phoneNumber])
                }
            }
        }
    }
    
    func saveFCMDeviceToken() {
        if let uid = Auth.auth().currentUser?.uid {
            if let fcmToken = Messaging.messaging().fcmToken {
                let tokenModel = TokenModel(id: fcmToken, token: fcmToken)
                let usersCollection = self.db.collection("users")
                do {
                    let _ = try usersCollection.document(uid).collection("tokens")
                        .document(fcmToken).setData(from: tokenModel) { error in
                        if let error = error {
                            print("Error adding token: \(error)")
                        } else {
                            print("Added TokenModel")
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    func registerUserForTopic(topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Error subscribing to topic: \(error)")
            } else {
                print("Subscribed to topic: \(topic)")
            }
        }
    }
    
    func updateUserModel(displayName: String?, major: String?, graduationYear: Int?, bio: String?) {
        if let uid = Auth.auth().currentUser?.uid {
            let profileRef = self.db.collection("users").document(uid)
            profileRef.updateData([
                "displayName": displayName as Any,
                "major": major as Any,
                "graduationYear": graduationYear as Any,
                "bio": bio as Any
            ]) { err in
                if let err = err {
                    print("Error updating profile: \(err)")
                } else {
                    print("Profile successfully updated")
                    self.getCurrentUserData()
                }
            }
        }
    }
    
    func updateUserProfilePhoto(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else {
            return
        }
        
        let config = CLDConfiguration(cloudName: "fitsatfit", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        
        let uploadRequestParams = CLDUploadRequestParams().setFolder("profilePhotos/\(Auth.auth().currentUser?.uid ?? "noUserId")")
        
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
            let imageUrl = downloadURL
            if let uid = Auth.auth().currentUser?.uid {
                let profileRef = self.db.collection("users").document(uid)
                profileRef.updateData([
                    "profilePicImageUrl": imageUrl as Any,
                ]) { err in
                    if let err = err {
                        print("Error updating profile pic: \(err)")
                    } else {
                        print("Profile pic successfully updated")
                        self.getCurrentUserData()
                    }
                }
            }
        }
    }
    
    func getPostAuthorMap() -> PostAuthorMap {
        return PostAuthorMap(displayName: self.userModel?.displayName, profilePicImageUrl: self.userModel?.profilePicImageUrl, userId: self.userModel?.id, pushNotificationToken: Messaging.messaging().fcmToken)
    }
}
