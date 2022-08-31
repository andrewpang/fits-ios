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
    @IBOutlet weak var applaudButtonImage: UIImageView!
    var blurEffectView: UIVisualEffectView?
    var participateLabel: UILabel?
    var multiPhotoIcon: UIImageView?
    
    var applaudButtonTapAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = Constants.buttonCornerRadius
        contentView.layer.masksToBounds = true
        
        portraitImage.layer.masksToBounds = true
        portraitImage.layer.cornerRadius = portraitImage.bounds.width / 2
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(applaudButtonTapped(tapGestureRecognizer:)))
        applaudButtonImage.isUserInteractionEnabled = true
        applaudButtonImage.addGestureRecognizer(tapGestureRecognizer)
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
    
    @objc func applaudButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
           // use our "call back" action to tell the controller the button was tapped
        applaudButtonTapAction?()
    }
    
    func showHighlightedApplaudButton() {
        let image = UIImage(systemName: "hands.clap.fill")!
        let yellowImage = image.withTintColor(UIColor(named: "FITColor") ?? .systemBlue, renderingMode: .alwaysOriginal)
        applaudButtonImage.image = yellowImage
    }
    
    func showUnhighlighedApplaudButton() {
        let image = UIImage(systemName: "hands.clap")!
        let grayImage = image.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        applaudButtonImage.image = grayImage
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
            blurEffectView.frame = image.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.center = image.center
            self.image.addSubview(blurEffectView)
            let blurEffect = UIBlurEffect(style: .regular)
            blurEffectView.effect = blurEffect
        }
        
        participateLabel = UILabel()
        if let participateLabel = participateLabel {
            participateLabel.frame = image.bounds
            participateLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
    func showMultiPhotoIcon() {
        hideMultiPhotoIcon()
        
        multiPhotoIcon = UIImageView(image: UIImage(systemName: "square.fill.on.square.fill"))
        if let multiPhotoIcon = multiPhotoIcon {
            multiPhotoIcon.frame = CGRect(x: image.frame.width - 28, y: 10, width: 18, height: 18)
            multiPhotoIcon.tintColor = .white
            self.image.addSubview(multiPhotoIcon)
        }
    }
    
    func hideMultiPhotoIcon() {
        if let multiPhotoIcon = multiPhotoIcon {
            multiPhotoIcon.removeFromSuperview()
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
