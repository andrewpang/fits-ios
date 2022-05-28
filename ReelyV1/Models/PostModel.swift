//
//  PostModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation

public struct PostModel: Identifiable, Codable, Hashable {
    public var id = UUID().uuidString
    let author: String
    let body: String
    var imageUrl: String
    let title: String
    let likes: Int
    
    init?(_ data: [String: Any]) {
        author = data["author"] as? String ?? ""
        body = data["body"] as? String ?? ""
        imageUrl = data["imageUrl"] as? String ?? ""
        title = data["title"] as? String ?? ""
        likes = data["likes"] as? Int ?? 0
    }
    
    init(author: String, body: String, imageUrl: String, title: String, likes: Int) {
        self.author = author
        self.body = body
        self.imageUrl = imageUrl
        self.title = title
        self.likes = likes
    }
    
    mutating func updateImageUrl(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
