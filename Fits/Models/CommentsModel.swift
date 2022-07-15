//
//  CommentsModel.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/5/22.
//

import Foundation

public struct CommentsModel: Identifiable, Codable, Hashable {
    public var id: String = UUID().uuidString
    var commentModels: [CommentModel]?
}
