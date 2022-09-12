//
//  UserPostViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 7/24/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserProfileViewModel: ObservableObject {
    @Published var userModel: UserModel? = nil
    @Published var postsData = PostsModel()
    @Published var postStreak = 0
    
    var profileListener: ListenerRegistration?
    var postsListener: ListenerRegistration?
    
    private var db = Firestore.firestore()
    
    func fetchUserModel(for userId: String) {
        if let _ = Auth.auth().currentUser?.uid {
            if (profileListener == nil) {
                profileListener = db.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    print("Current data: \(data)")
                    guard let userData = try? document.data(as: UserModel.self) else {
                        print("Couldn't parse user data to UserModel")
                        return
                    }
                    self.userModel = userData
                }
            }
        }
    }
    
    func fetchCurrentUserPosts() {
        if (postsListener != nil) {
            return
        }
        if let uid = Auth.auth().currentUser?.uid {
            postsListener = db.collection("posts")
                .whereField("author.userId", isEqualTo: uid)
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }

                    var postList = [PostModel]()
                    postList = documents.compactMap { querySnapshot -> PostModel? in
                        return try? querySnapshot.data(as: PostModel.self)
                    }
                    DispatchQueue.main.async {
                        self.postsData = PostsModel(postModels: postList)
                        self.getPostStreak()
                    }
            }
        }
    }
    
    func fetchPostsForUser(for userId: String) {
        if (postsListener != nil) {
            return
        }
        if let _ = Auth.auth().currentUser?.uid {
            postsListener = db.collection("posts")
                .whereField("author.userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true).addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }

                    var postList = [PostModel]()
                    postList = documents.compactMap { querySnapshot -> PostModel? in
                        return try? querySnapshot.data(as: PostModel.self)
                    }
                    DispatchQueue.main.async {
                        self.postsData = PostsModel(postModels: postList)
                        self.getPostStreak()
                    }
                }
        }
    }
    
    func getPostStreak() {
        var streak = 0
        var date = Timestamp.init().dateValue()
        if let postModels = postsData.postModels {
            for post in postModels {
                if let postTime = post.createdAt?.dateValue() {
                    if (isSameDay(date1: date, date2: postTime)) {
                        streak += 1
                        if let oneDayBack = date.getDateFor(days: -1) {
                            date = oneDayBack
                        } else {
                            break;
                        }
                    } else if (isWithin24Hours(date1: postTime, date2: date)) {
                        streak += 1
                        if let oneDayBack = date.getDateFor(days: -2) {
                            date = oneDayBack
                        } else {
                            break;
                        }
                    }
                    else {
                        if (isAheadOfDate(date1: postTime, date2: date)) {
                            continue;
                        }
                        break;
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.postStreak = streak
        }
    }
    
    func isAheadOfDate(date1: Date, date2: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let diff = calendar.dateComponents([.hour], from: date1, to: date2)
        if let diffHour = diff.hour, diffHour < 0 {
            return true
        } else {
            return false
        }
    }
                    
    func isWithin24Hours(date1: Date, date2: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let diff = calendar.dateComponents([.hour], from: date1, to: date2)
        if let diffHour = diff.hour, diffHour < 24, diffHour >= 0 {
            return true
        } else {
            return false
        }
    }

    func isSameDay(date1: Date, date2: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func removeListeners() {
        profileListener?.remove()
        postsListener?.remove()
    }
}

extension Date {
    func getDateFor(days: Int) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar.date(byAdding: .day, value: days, to: self)
    }
}
