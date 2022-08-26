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
    var blurEffectView: UIVisualEffectView?
    var participateLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = Constants.buttonCornerRadius
        contentView.layer.masksToBounds = true
        
        portraitImage.layer.masksToBounds = true
        portraitImage.layer.cornerRadius = portraitImage.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = UIImage(named: "placeHolder")
        portraitImage.image = UIImage(named: "portraitPlaceHolder")
        removeBlurAndAddPromptButton()
//        let constraints = [
//            postTitleLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
//            postTitleLabel.bottomAnchor.constraint(equalTo: postAuthorView.topAnchor)
//        ]
//        NSLayoutConstraint.activate(constraints)
    }
    
    func setImageUrl(urlString: String) {
        image.kf.indicatorType = .activity
        image.kf.setImage(with: URL(string: urlString))
    }
    
    func setProfileImageUrl(urlString: String) {
        portraitImage.kf.setImage(with: URL(string: urlString))
    }
    
    func setBlurAndAddPromptButton() {
        removeBlurAndAddPromptButton()

        blurEffectView = UIVisualEffectView()
        if let blurEffectView = blurEffectView {
            blurEffectView.frame = CGRect(x: 0, y: 0, width: image.frame.width, height: image.frame.height)
            blurEffectView.center = image.center
            self.image.addSubview(blurEffectView)
            let blurEffect = UIBlurEffect(style: .regular)
            blurEffectView.effect = blurEffect
        }
        
        participateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        if let participateLabel = participateLabel {
            participateLabel.center = image.center
            participateLabel.text = "Participate in Fit Check to View!"
            participateLabel.numberOfLines = 0
            participateLabel.font = UIFont(name: Constants.titleFont, size: 24)
            participateLabel.textColor = .white
            self.contentView.addSubview(participateLabel)
            participateLabel.setMargins()
            participateLabel.textAlignment = .center
        }
    }
    
    func removeBlurAndAddPromptButton() {
        if let blurEffectView = blurEffectView {
            blurEffectView.removeFromSuperview()
        }
        if let participateLabel = participateLabel {
            participateLabel.removeFromSuperview()
        }
    }
}

extension UILabel {
    func setMargins(margin: CGFloat = 20) {
        if let textString = self.text {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
