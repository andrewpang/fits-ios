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
    @Published var followerData: FollowerModel = FollowerModel()
    @Published var followingData = [FollowerModel]()
    
    let db = Firestore.firestore()
    
    private let auth = Auth.auth()
    
    var profileListener: ListenerRegistration?
    var followersListener: ListenerRegistration?
    var followingListener: ListenerRegistration?
    
    func checkIfSignedIn() {
        if (Auth.auth().currentUser != nil) {
            getCurrentUserData()
        } else {
            Amplitude.instance().setUserId(nil)
            Mixpanel.mainInstance().reset()
            followerData = FollowerModel()
            followingData = [FollowerModel]()
            state = .signedOut
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            Amplitude.instance().setUserId(nil)
            Mixpanel.mainInstance().reset()
            followerData = FollowerModel()
            followingData = [FollowerModel]()
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
                    self.getFollowersList()
                    self.getFollowingList()
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
    
    func followUser(with userId: String) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let followersDocument = self.db.collection("followers").document(userId)
            let userDisplayName = userModel?.displayName ?? "Someone"
            let notificationText = "\(userDisplayName) just followed you!"
            let notificationModel = NotificationModel(userId: userId, text: notificationText, type: "newFollower", followerUserId: currentUserId)
            let notificationDocument = self.db.collection("notifications").document(notificationModel.id ?? UUID().uuidString)
            do {
                let batch = db.batch()
                try batch.setData(from: notificationModel, forDocument: notificationDocument, merge: true)
                batch.setData([
                    "users": FieldValue.arrayUnion([currentUserId])
                ], forDocument: followersDocument, merge: true)
                batch.commit() { err in
                    if let err = err {
                        print("Error writing followUser batch \(err)")
                    } else {
                        print("Batch write for followUser succeeded.")
                        let eventName = "Follow User - Clicked"
                        let propertiesDict = [
                            "followerUserId": currentUserId,
                            "followingUserId": userId
                        ] as? [String : String]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                    }
                }
            }
            catch {
                print (error)
            }
        }
    }
    
    func unfollowUser(with userId: String) {
        if let currentUserId = Auth.auth().currentUser?.uid {
            let followersRef = self.db.collection("followers").document(userId)
            followersRef.updateData([
                "users": FieldValue.arrayRemove([currentUserId])
            ]) { err in
                if let err = err {
                    print("Error unfollowing user: \(err)")
                } else {
                    print("User successfuly unfollowed")
                    let eventName = "Unfollow User - Clicked"
                    let propertiesDict = [
                        "followerUserId": currentUserId,
                        "unfollowedUserId": userId
                    ] as? [String : String]
                    Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                    Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
                }
            }
        }
    }
    
    func getFollowersList() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            if (followersListener != nil) {
                return
            }
            let fetchFollowersQuery = db.collection("followers").document(currentUserId)
                
            followersListener = fetchFollowersQuery.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                guard let followerData = try? document.data(as: FollowerModel.self) else {
                    print("Couldn't parse user data to UserModel")
                    return
                }
                
                DispatchQueue.main.async {
                    self.followerData = followerData
                }
            }
        }
    }
    
    func getFollowingList() {
        if let currentUserId = Auth.auth().currentUser?.uid {
            if (followingListener != nil) {
                return
            }
            let fetchFollowingQuery = db.collection("followers").whereField("users", arrayContains: currentUserId)
                
            followingListener = fetchFollowingQuery.addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }

                var followingList = [FollowerModel]()
                followingList = documents.compactMap { querySnapshot -> FollowerModel? in
                    return try? querySnapshot.data(as: FollowerModel.self)
                }
                DispatchQueue.main.async {
                    self.followingData = followingList
                }
            }
        }
    }
    
    func isFollowingUser(with userId: String) -> Bool {
        for following in followingData {
            if (following.id == userId) {
                return true
            }
        }
        return false
    }
    
    func isUserFollowingCurrentUser(with userId: String) -> Bool {
        if let followers = followerData.users {
            return followers.contains(userId)
        }
        return false
    }
}
