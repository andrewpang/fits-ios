//
//  PostPromptMap.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import Foundation
import Firebase

public struct PostPromptMap: Codable, Hashable {
    var title: String?
    var promptId: String?
    var endTime: Timestamp?
    
    func promptHasAlreadyEnded() -> Bool {
        if let endTime = endTime {
            return endTime.seconds < Timestamp.init().seconds
        }
        return false
    }
}
