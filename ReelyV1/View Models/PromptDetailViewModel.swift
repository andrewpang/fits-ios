//
//  PromptDetailViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import Foundation
import Firebase

class PromptDetailViewModel: ObservableObject {
    
    @Published var detailViewIsActive = false
    
    @Published var promptModel: PromptModel
    @Published var postsData = PostsModel()
    var promptPostModel: PromptPostModel?
    
    private var db = Firestore.firestore()
    
    var promptPostsListener: ListenerRegistration?
    
    init(promptModel: PromptModel, promptPostModel: PromptPostModel?) {
        self.promptModel = promptModel
        self.promptPostModel = promptPostModel
    }
    
    func fetchPostsForPrompt() {
        if (promptPostsListener != nil) {
            return
        }
        
        var fetchPromptPostsQuery: Query
        fetchPromptPostsQuery = db.collection("posts")
            .whereField("prompt.promptId", isEqualTo: promptModel.id)
            .order(by: "createdAt", descending: true)
        
        promptPostsListener = fetchPromptPostsQuery.addSnapshotListener { (querySnapshot, error) in
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
            }
        }
        
    }
    
    func userHasPostedInLastDay() -> Bool {
        if let promptPostModel = promptPostModel {
            if let postedTimestamps = promptPostModel.postedTimestamps {
                for timestamp in postedTimestamps {
                    if (isSameDay(date1: timestamp.dateValue(), date2: Timestamp.init().dateValue())) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func resetData() {
        DispatchQueue.main.async {
            self.promptModel = PromptModel(title: "")
            self.postsData = PostsModel()
        }
    }
    
    func removeListeners() {
        promptPostsListener?.remove()
    }
}

