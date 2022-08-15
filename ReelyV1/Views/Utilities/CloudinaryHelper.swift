//
//  CloudinaryHelper.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import Foundation

class CloudinaryHelper {
    static let thumbnailWidth = 600
    static let detailWidth = 1200
    
    static func getCompressedUrl(url: String, width: Int) -> String {
        if (!url.contains("cloudinary")) {
            return url
        } else {
            let cloudinaryPrefix = "https://res.cloudinary.com/fitsatfit/image/upload/"
            let parsed = url.replacingOccurrences(of: cloudinaryPrefix, with: "")
            return cloudinaryPrefix + "w_\(width)/" + parsed
        }
    }
}
