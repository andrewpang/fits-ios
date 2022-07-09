//
//  UserModel.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/3/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

public struct UserModel: Codable {
    @DocumentID public var id: String? = UUID().uuidString
    @ServerTimestamp var createdAt: Timestamp?
    var displayName: String
    var bio: String?
    var profilePicImageUrl: String?
    var groups: [String]?
    var phoneNumber: String?
    
    //College-Specific
    var school: String?
    var major: String?
    var graduationYear: Int?
}
