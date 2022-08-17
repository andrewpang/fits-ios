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
    var imageUrl: String?
    var imageUrls: [String]?
    var title: String
    var body: String
    var likesCount: Int?
    var tags: [String]?
    var groupId: String?
    var thumbnailHeight: Double?
    var thumbnailWidth: Double?
    
    mutating func incrementLikesCount(number: Int) {
        if (likesCount != nil) {
            likesCount! += number
        }
    }
    
    func getThumbnailAspectRatio() -> Double {
        if let thumbnailWidth = thumbnailWidth {
            if let thumbnailHeight = thumbnailHeight {
                return thumbnailHeight/thumbnailWidth
            }
        }
        return 0.0
    }
}
