//
//  FollowerUserModel.swift
//  FITs
//
//  Created by Andrew Pang on 9/15/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct FollowerUserModel: Codable {
    @DocumentID public var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var author: PostAuthorMap
}
