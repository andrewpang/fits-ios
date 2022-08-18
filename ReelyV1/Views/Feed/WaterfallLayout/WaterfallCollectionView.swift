//
//  WaterfallCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI

struct WaterfallCollectionViewController: UIViewControllerRepresentable {
    
    @Binding var postsModel: PostsModel
    var uiCollectionViewController: UICollectionViewController
    
    typealias UIViewControllerType = UICollectionViewController

    func makeUIViewController(context: Context) -> UICollectionViewController {
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = Constants.postCardPadding
        layout.minimumInteritemSpacing = Constants.postCardPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.postCardPadding, bottom: 0, right: Constants.postCardPadding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator

        // Collection view attributes
        collectionView.alwaysBounceVertical = true

        // Add the waterfall layout to your collection view
        collectionView.collectionViewLayout = layout
        
        collectionView.showsVerticalScrollIndicator = false
        
        uiCollectionViewController.collectionView = collectionView
        uiCollectionViewController.collectionView.backgroundColor = UIColor(named: Constants.onBoardingButtonColor)
        
        let viewNib = UINib(nibName: "ImageUICollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
        
        
        return uiCollectionViewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
        //TODO: Look into if there's a more perfomant way to handle this
        uiViewController.collectionView.reloadData()
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
            if let post = parent.postsModel.postModels?[indexPath.item] {
                if (post.getThumbnailAspectRatio() > 0.0) {
                    let cardImageHeight = cardWidth * post.getThumbnailAspectRatio()
                    let postTitleHeight = (50.0/183.0) * cardWidth
                    let postAuthorViewHeight = (28.0/183.0) * cardWidth
                    let cardHeight = cardImageHeight + postTitleHeight + postAuthorViewHeight
                    print("Width: \(cardWidth)") //183
                    print("Height: \(cardHeight)") //image + 50 + 28
                    return CGSize.init(width: cardWidth, height: cardHeight)
                }
            }
            //Return a default aspect ratio, if none set
            return CGSize.init(width: 200.0, height: 400.0)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            parent.postsModel.postModels?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageUICollectionViewCell
            // Add image to cell
            if let post = parent.postsModel.postModels?[indexPath.item] {
                if let imageUrl = post.imageUrls?[0] {
                    cell.setImageUrl(urlString: imageUrl)
                } else if let imageUrl = post.imageUrl {
                    cell.setImageUrl(urlString: imageUrl)
                } else {
                    //TODO: clear image so it doesn't get improperly recycled
                }
                cell.postTitleLabel.text = post.title
                if let authorName = post.author.displayName {
                    cell.postAuthorLabel.text = authorName
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let post = parent.postsModel.postModels?[indexPath.item] {
                let postDetailView = PostDetailView(postDetailViewModel: PostDetailViewModel(postModel: post))
                let host = UIHostingController(rootView: postDetailView)
                uiCollectionViewController.navigationController?.pushViewController(host, animated: true)
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
