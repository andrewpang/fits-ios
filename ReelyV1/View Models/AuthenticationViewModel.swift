//
//  AuthenticationViewModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/29/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""

    enum SignInState {
        case signedIn
        case signedOut
        case loading
    }

    @Published var state: SignInState = .loading
    
    let db = Firestore.firestore()
    
    private let auth = Auth.auth()
    
    func checkIfSignedIn() {
        if (Auth.auth().currentUser != nil) {
            getCurrentUserData()
        } else {
            state = .signedOut
        }
    }
    
    func getCurrentUserData() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).getDocument(completion: { (documentSnapshot, err) in
                if let displayName = documentSnapshot?.get("displayName") as? String {
                    self.displayName = displayName
                }
                if let email = documentSnapshot?.get("email") as? String {
                    self.email = email
                }
                self.state = .signedIn
            })
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            if let uid = authResult?.user.uid {
                let userDoc = self.db.collection("users").document(uid)
                userDoc.setData(
                    [
                        "displayName" : self.displayName,
                        "email": self.email
                    ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully updated!")
                        self.state = .signedIn
                    }
                }
            }
        }
    }
    
    func signUpWithMagicLink() {
        
    }
    
    private var verificationId: String?
    
    public func startSMSAuth(phoneNumber:String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifySMSCode(smsCode:String, completion: @escaping (Bool) -> Void) {
       
    }
    
    func uploadProfilePicture() {
        //            let storage = Storage.storage()
        //            let imagesRef = storage.reference().child("images")
        //
        //            let imageRef = imagesRef.child(UUID().uuidString)
        //
        //            let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
        //                // You can also access to download URL after upload.
        //                imageRef.downloadURL { (url, error) in
        //                    guard let downloadURL = url else {
        //                        // Uh-oh, an error occurred!
        //                        return
        //                    }
        //                    let postModel = PostModel(author: author, body: body, imageUrl: downloadURL.absoluteString, title: title, likes: 0)
        //                    self.uploadPostModel(postModel: postModel)
        //                }
        //            }
    }
    
    func signOut() {
        
    }
    
    
}
