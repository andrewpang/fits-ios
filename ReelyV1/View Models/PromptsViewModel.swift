//
//  PromptsViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import Foundation
import Firebase

class PromptsViewModel: ObservableObject {
    
    @Published var promptsData = PromptsModel()
    @Published var shouldPopToRootViewIfFalse = false

    private var db = Firestore.firestore()
    
    @Published var promptIdToPostPromptMapDictionary: [String: PromptPostModel] = [:]
    
    var promptsListener: ListenerRegistration?
    var promptPostsListener: ListenerRegistration?

    func fetchPrompts(userId: String) {
        if (promptsListener != nil) {
            return
        }
        
        var fetchPromptsQuery: Query
        fetchPromptsQuery = db.collection("prompts")
            .order(by: "endTime", descending: true)
        
        
        promptsListener = fetchPromptsQuery.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            var promptList = [PromptModel]()
            promptList = documents.compactMap { querySnapshot -> PromptModel? in
                return try? querySnapshot.data(as: PromptModel.self)
            }
            DispatchQueue.main.async {
                self.promptsData = PromptsModel(promptModels: promptList)
                self.fetchPostPromptMapping(userId: userId)
            }
        }
    }
    
    func fetchPostPromptMapping(userId: String) {
        if (promptPostsListener != nil) {
            return
        }
        
        if let promptModels = promptsData.promptModels {
            for promptModel in promptModels {
                if let promptId = promptModel.id {
                    let documentId = "\(userId)_\(promptId)"
                    let fetchPromptPostQuery = db.collection("promptPosts").document(documentId)
                    promptPostsListener = fetchPromptPostQuery.addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        guard let data = document.data() else {
                            print("Document data was empty.")
                            return
                        }
                        print("Current data: \(data)")
                        let promptPostModel = try? document.data(as: PromptPostModel.self)
                        DispatchQueue.main.async {
                            self.promptIdToPostPromptMapDictionary[promptId] = promptPostModel
                        }
                    }
                }
            }
        }
    }
    
    func hasCurrentUserPostedToPrompt(with promptId: String?) -> Bool {
        return promptIdToPostPromptMapDictionary.keys.contains(promptId ?? "noId")
    }
    
    func removeListeners() {
        promptsListener?.remove()
        promptPostsListener?.remove()
    }
}
