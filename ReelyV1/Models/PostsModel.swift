//
//  PostsModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 5/23/22.
//

import Foundation

public struct PostsModel: Identifiable, Codable, Hashable {
    public var id = UUID().uuidString
    var postModels: [PostModel]?
}
