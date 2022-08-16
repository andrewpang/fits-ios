//
//  WaterfallCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI

struct WaterfallCollectionViewController: UIViewControllerRepresentable {
    
    var postModels: [PostModel]
    var uiCollectionViewController: UICollectionViewController
    
    typealias UIViewControllerType = UICollectionViewController

    func makeUIViewController(context: Context) -> UICollectionViewController {
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = Constants.postCardPadding
        layout.minimumInteritemSpacing = Constants.postCardPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.postCardPadding, bottom: 0, right: Constants.postCardPadding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let cellIdentifier = "hostCell"
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator

        // Collection view attributes
        collectionView.alwaysBounceVertical = false

        // Add the waterfall layout to your collection view
        collectionView.collectionViewLayout = layout
        
        uiCollectionViewController.collectionView = collectionView
        uiCollectionViewController.collectionView.backgroundColor = UIColor(named: Constants.onBoardingButtonColor)
        
        return uiCollectionViewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, uiCollectionViewController: uiCollectionViewController)
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        var parent: WaterfallCollectionViewController
        var uiCollectionViewController: UICollectionViewController
        var screenWidth = 0.0
        var cardWidth = 0.0

        init(_ parent: WaterfallCollectionViewController, uiCollectionViewController: UICollectionViewController) {
            self.parent = parent
            self.uiCollectionViewController = uiCollectionViewController
            self.screenWidth = UIScreen.main.bounds.width
            self.cardWidth = (screenWidth - (Constants.postCardPadding * 3)) / 2
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let post = parent.postModels[indexPath.item]
            let postTitle = post.title
            if let aspectRatio = post.thumbnailAspectRatio {
                let cardImageHeight = cardWidth * aspectRatio
                if let font = UIFont(name: Constants.titleFontBold, size: Constants.postCardTitleFontSize) {
                    let postTitleHeight = postTitle.height(withConstrainedWidth: cardWidth - (2 * Constants.postCardTitleHorizontalPadding), font: font)
                    let postTitleHeightWithPadding = postTitleHeight + (2 * Constants.postCardTitleVerticalPadding)
                    let cardHeight = cardImageHeight + postTitleHeightWithPadding + Constants.postCardAuthorSectionHeight
                    return CGSize.init(width: cardWidth, height: cardHeight)
                }
            }
            //Return a default aspect ratio, if none set
            return CGSize.init(width: 200, height: 350)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            parent.postModels.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellIdentifier = "hostCell"
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = PostCardView(post: parent.postModels[indexPath.item])
            return hostCell!
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let postDetailView = PostDetailView(postDetailViewModel: PostDetailViewModel(postModel: parent.postModels[indexPath.item]))
            let host = UIHostingController(rootView: postDetailView)
            uiCollectionViewController.navigationController?.pushViewController(host, animated: true)
        }
    }
    
    private class HostCell: UICollectionViewCell {
           private var hostController: UIHostingController<PostCardView>?
           
           override func prepareForReuse() {
               if let hostView = hostController?.view {
                   hostView.removeFromSuperview()
               }
               hostController = nil
           }
           
           var hostedCell: PostCardView? {
               willSet {
                   guard let view = newValue else { return }
                   hostController = UIHostingController(rootView: view)
                   if let hostView = hostController?.view {
                       hostView.frame = contentView.bounds
//                       hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                       hostView.translatesAutoresizingMaskIntoConstraints = false
                       contentView.addSubview(hostView)
                   }
               }
           }
       }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.width)
    }
}
