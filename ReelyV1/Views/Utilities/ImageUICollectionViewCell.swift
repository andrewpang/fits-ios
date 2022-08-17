//
//  ImageUICollectionViewCell.swift
//  FITs
//
//  Created by Andrew Pang on 8/16/22.
//

import UIKit
import Kingfisher

class ImageUICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var portraitImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        portraitImage.layer.masksToBounds = true
        portraitImage.layer.cornerRadius = portraitImage.bounds.width / 2
    }
    
    func setImageUrl(urlString: String) {
        image.kf.setImage(with: URL(string: urlString))
    }
}
