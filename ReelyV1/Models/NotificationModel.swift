//
//  NotificationModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/15/22.
//

import Foundation

import FirebaseFirestoreSwift
import FirebaseFirestore

public struct NotificationModel: Codable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var userId: String?
    var text: String
    var type: String?
    var interactorUserId: String? //Used for follower, bookmarker, liker, etc.
}
