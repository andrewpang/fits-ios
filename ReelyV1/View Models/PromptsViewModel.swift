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
    
    var promptsListener: ListenerRegistration?

    func fetchPrompts() {
        if (promptsListener != nil) {
            return
        }
        
        var fetchPromptsQuery: Query
        fetchPromptsQuery = db.collection("prompts")
            .whereField("endTime", isGreaterThan: Timestamp.init())
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
            }
        }
    }
    
    func removeListeners() {
        promptsListener?.remove()
    }
}
