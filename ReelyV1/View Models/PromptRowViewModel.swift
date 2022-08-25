//
//  PromptRowViewModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import Foundation
import Firebase

class PromptRowViewModel: ObservableObject {
    
    @Published var promptModel: PromptModel
    @Published var isBlurred = true
    
    private var db = Firestore.firestore()
    
    init(promptModel: PromptModel) {
        self.promptModel = promptModel
    }
    
    func getPromptRowIsBlurred(userId: String) {
        if let promptId = promptModel.id {
            let documentId = "\(userId)_\(promptId)"
            let fetchPromptPostQuery = db.collection("promptPosts").document(documentId)
            fetchPromptPostQuery.getDocument { (document, error) in
                if let document = document, document.exists {
                    DispatchQueue.main.async {
                        self.isBlurred = false
                    }
                } else {
                    print("Document does not exist")
                    DispatchQueue.main.async {
                        self.isBlurred = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isBlurred = true
            }
        }
    }
}
