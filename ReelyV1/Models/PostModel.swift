//
//  PostModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct PostModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var author: PostAuthorMap
    var imageUrl: String
    var title: String
    var body: String
    var likes: Int
    var tags: [String]?
}
