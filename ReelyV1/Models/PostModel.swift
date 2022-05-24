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
    let imageUrl: String
    let title: String
    let likes: Int
    
    init?(_ data: [String: Any]) {
        author = data["author"] as? String ?? ""
        body = data["body"] as? String ?? ""
        imageUrl = data["imageUrl"] as? String ?? ""
        title = data["title"] as? String ?? ""
        likes = data["likes"] as? Int ?? 0
    }
}
