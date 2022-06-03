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
    var imageUrl: String
//    let title: String
    let likes: Int
    
    let brandName: String
    let productName: String
    let price: String
    let body: String
    
    init?(_ data: [String: Any]) {
        author = data["author"] as? String ?? ""
        imageUrl = data["imageUrl"] as? String ?? ""
//        title = data["title"] as? String ?? ""
        likes = data["likes"] as? Int ?? 0
        
        brandName = data["brandName"] as? String ?? ""
        productName = data["productName"] as? String ?? ""
        price = data["price"] as? String ?? ""
        body = data["body"] as? String ?? ""
    }
    
    init(author: String, imageUrl: String, likes: Int, brandName: String, productName: String, price: String, body: String) {
        self.author = author
        self.imageUrl = imageUrl
//        self.title = title
        self.likes = likes
        
        self.brandName = brandName
        self.productName = productName
        self.price = price
        self.body = body
    }
    
    mutating func updateImageUrl(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
