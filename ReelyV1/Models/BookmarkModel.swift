//
//  BookmarkModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/20/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct BookmarkModel: Codable {
    @DocumentID public var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var bookmarkerId: String?
    var postId: String?
    var boardIds: [String]?
}
