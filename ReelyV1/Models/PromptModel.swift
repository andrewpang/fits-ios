//
//  PromptModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

public struct PromptModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var startTime: Timestamp?
    var endTime: Timestamp?
    var title: String?
    var previewImageUrls: [String]?
    
    func promptHasAlreadyEnded() -> Bool {
        if let endTime = endTime {
            return endTime.seconds < Timestamp.init().seconds
        }
        return false
    }
    
    func getFormattedDateString() -> String? {
        if let endTime = endTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let endTimeString = dateFormatter.string(from: endTime.dateValue())
            return endTimeString
        }
        return nil
    }
}
