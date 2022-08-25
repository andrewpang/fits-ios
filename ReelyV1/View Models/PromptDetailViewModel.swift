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

    private var db = Firestore.firestore()
    
    var promptPostsListener: ListenerRegistration?
    
    init(promptModel: PromptModel) {
        self.promptModel = promptModel
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
    
    func resetData() {
        promptModel = PromptModel(title: "")
        postsData = PostsModel()
    }
    
    func removeListeners() {
        promptPostsListener?.remove()
    }
}

