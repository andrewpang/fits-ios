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
    @ServerTimestamp var createdAt: Timestamp?
    var text: String
    var type: String?
}
