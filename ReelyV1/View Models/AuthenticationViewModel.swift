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

    enum SignInState {
    case signedIn
    case signedOut
    }

    @Published var state: SignInState = .signedOut

    func createUser(withEmail: String, password: String) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { authResult, error in
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
        
        
    }
    
    func signOut() {
        
    }
    
    
}
