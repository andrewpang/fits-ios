//
//  FollowerFollowingViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/14/22.
//

import Foundation
import FirebaseFirestore

class FollowerFollowingViewModel: ObservableObject {
    
    @Published var userModel = UserModel()
    
    let db = Firestore.firestore()
    
    func getUserModel(with userId: String) {
        if (userModel.id == userId) {
            return
        }
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                   print("Document data was empty.")
                   return
               }
               print("Current data: \(data)")
               guard let userData = try? document.data(as: UserModel.self) else {
                   print("Couldn't parse user data to UserModel")
                   return
               }
                DispatchQueue.main.async {
                    self.userModel = userData
                }
            } else {
                print("Document does not exist")
            }
        }
    }

//    func getUserModel(with userId: String) {
//       if (profileListener == nil) {
//           profileListener = db.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
//               guard let document = documentSnapshot else {
//                   print("Error fetching document: \(error!)")
//                   return
//               }
//               guard let data = document.data() else {
//                   print("Document data was empty.")
//                   return
//               }
//               print("Current data: \(data)")
//               guard let userData = try? document.data(as: UserModel.self) else {
//                   print("Couldn't parse user data to UserModel")
//                   return
//               }
//
//               DispatchQueue.main.async {
//                   self.userModel = userData
//               }
//           }
//       }
//    }
}
