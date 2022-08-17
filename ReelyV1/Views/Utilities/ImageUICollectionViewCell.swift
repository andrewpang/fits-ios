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
    @IBOutlet weak var postAuthorView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        portraitImage.layer.masksToBounds = true
        portraitImage.layer.cornerRadius = portraitImage.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        postTitleLabel.text = ""
//        postAuthorLabel.text = ""
//        image.image = nil
//        portraitImage.image = nil
//        let constraints = [
//            postDetailView.topAnchor.constraint(equalTo: image.bottomAnchor),
//            postDetailView.bottomAnchor.constraint(equalTo: postDetailView.superview!.bottomAnchor),
//            postTitleLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
//            postTitleLabel.bottomAnchor.constraint(equalTo: postAuthorView.topAnchor)
//        ]
//        NSLayoutConstraint.activate(constraints)
    }
    
    func setImageUrl(urlString: String) {
        image.kf.setImage(with: URL(string: urlString))
    }
}
