//
//  CommentLikeModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/1/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct CommentLikeModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var commentId: String?
    var author: PostAuthorMap
}
