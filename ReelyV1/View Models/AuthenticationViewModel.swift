//
//  AuthenticationViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging

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
    
    func checkIfSignedIn() {
//        signOut()
        if (Auth.auth().currentUser != nil) {
            getCurrentUserData()
        } else {
            state = .signedOut
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
        }
    }
    
    func getCurrentUserData() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).getDocument(completion: { (documentSnapshot, err) in
                if let error = err {
                    self.state = .signedOut
                    print (error)
                    return
                }
                if let document = documentSnapshot, document.exists {
                    self.userModel = try? document.data(as: UserModel.self)
                    self.state = .signedIn
                    self.saveFCMDeviceToken()
                } else {
                    print("Auth: Empty Profile")
                    self.state = .signedIn //TODO: might have to bring up part of onboarding flow again
                    self.saveFCMDeviceToken()
                }
            })
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
    
    func getPostAuthorMap() -> PostAuthorMap {
        return PostAuthorMap(displayName: userModel?.displayName, profilePicImageUrl: userModel?.profilePicImageUrl, userId: userModel?.id)
    }
}
