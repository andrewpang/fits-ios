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
        if let promptModels = promptsData.promptModels {
            for promptModel in promptModels {
                if let promptId = promptModel.id {
                    let documentId = "\(userId)_\(promptId)"
                    let fetchPromptPostQuery = db.collection("promptPosts").document(documentId)
                    fetchPromptPostQuery.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let promptPostModel = try? document.data(as: PromptPostModel.self)
                            DispatchQueue.main.async {
                                self.promptIdToPostPromptMapDictionary[promptId] = promptPostModel
                            }
                        } else {
                            print("Document does not exist")
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
    }
}
