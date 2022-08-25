//
//  PromptPostModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/25/22.
//

import Foundation
import Firebase

public struct PromptPostModel: Codable {
    var postId: String?
    var userId: String?
    var postedTimestamps: [Timestamp]?
}
