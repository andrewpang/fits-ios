//
//  TokenModel.swift
//  FIT(s)
//
//  Created by Andrew Pang on 7/6/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct TokenModel: Codable {
    @DocumentID public var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    var token: String
}
