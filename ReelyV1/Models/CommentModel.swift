//
//  CommentModel.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct CommentModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var author: PostAuthorMap
    var commentText: String
    var commentLikeCount: Int?
}
