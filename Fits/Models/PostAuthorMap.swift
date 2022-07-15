//
//  PostAuthorMap.swift
//  ReelyV1
//
//  Created by Andrew Pang on 7/2/22.
//

import Foundation

public struct PostAuthorMap: Codable, Hashable {
    var displayName: String?
    var profilePicImageUrl: String?
    var userId: String?
    var pushNotificationToken: String?
}
