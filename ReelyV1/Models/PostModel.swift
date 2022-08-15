//
//  PostModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Cloudinary

let thumbnailWidth = 600
let compressedWidth = 1200

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
    
    mutating func incrementLikesCount(number: Int) {
        if (likesCount != nil) {
            likesCount! += number
        }
    }
    
    func getThumbnailUrl() -> String {
        if let firstImageUrl = imageUrls?[0] {
            if (!firstImageUrl.contains("cloudinary")) {
                return firstImageUrl
            } else {
                let cloudinaryPrefix = "https://res.cloudinary.com/fitsatfit/image/upload/"
                let parsed = firstImageUrl.replacingOccurrences(of: cloudinaryPrefix, with: "")
                return cloudinaryPrefix + "w_\(thumbnailWidth)/" + parsed
            }
        }
        return ""
    }
    
    static func getCompressedUrl(url: String) -> String {
        if (!url.contains("cloudinary")) {
            return url
        } else {
            let cloudinaryPrefix = "https://res.cloudinary.com/fitsatfit/image/upload/"
            let parsed = url.replacingOccurrences(of: cloudinaryPrefix, with: "")
            return cloudinaryPrefix + "w_\(compressedWidth)/" + parsed
        }
    }
}
