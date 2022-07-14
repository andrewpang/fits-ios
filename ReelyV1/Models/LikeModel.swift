//
//  LikeModel.swift
//  FITs
//
//  Created by Andrew Pang on 7/13/22.
//
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct LikeModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var author: PostAuthorMap
}
