//
//  BookmarkBoardModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/20/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct BookmarkBoardModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var lastUpdated: Timestamp?
    var creatorId: String?
    var title: String?
    var description: String?
    var previewImageUrl: String?
}
