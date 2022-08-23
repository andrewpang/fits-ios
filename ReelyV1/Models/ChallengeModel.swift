//
//  ChallengeModel.swift
//  FITs
//
//  Created by Andrew Pang on 8/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct ChallengeModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var startTime: Timestamp?
    var endTime: Timestamp?
    var title: String
    var previewPosts: PostsModel
}
