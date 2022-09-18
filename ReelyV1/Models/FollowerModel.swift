//
//  FollowerModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/13/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct FollowerModel: Codable {
    @DocumentID public var id: String?
    var mostRecentPostTimestamp: Timestamp?
    var users: [String]?
    var recentPosts: [PostModel]?
}
