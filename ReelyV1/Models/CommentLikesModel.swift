//
//  CommentLikesModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/5/22.
//

import Foundation

public struct CommentLikesModel: Codable, Hashable {
    var commentLikeModels: [CommentLikeModel]?
    
    func hasUserHasLikedComment(with userId: String) -> Bool {
        if let commentLikeModels = commentLikeModels {
            for commentLikeModel in commentLikeModels {
                if (commentLikeModel.id == userId) {
                    return true
                }
            }
        }
        return false
    }
}
