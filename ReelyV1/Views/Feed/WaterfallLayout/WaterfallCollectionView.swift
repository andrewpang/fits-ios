//
//  WaterfallCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI


// WARNING: When updating, check if needs to update WaterfallPromptCollectionView
struct WaterfallCollectionViewController: UIViewControllerRepresentable {
    
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var selectedPostDetail: PostDetailViewModel
    
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
        uiCollectionViewController.collectionView.backgroundColor = UIColor(named: Constants.backgroundColor)
        
        let viewNib = UINib(nibName: "ImageUICollectionViewCell", bundle: nil)
        collectionView.register(viewNib, forCellWithReuseIdentifier: "cell")
        
        return uiCollectionViewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
        //TODO: Look into if there's a more perfomant way to handle this
        uiViewController.collectionView.reloadData()
        if (homeViewModel.shouldScrollToTop) {
            uiViewController.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                        animated: true)
            homeViewModel.shouldScrollToTop = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, uiCollectionViewController: uiCollectionViewController, postDetailViewModel: $selectedPostDetail)
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        var parent: WaterfallCollectionViewController
        var uiCollectionViewController: UICollectionViewController
        var screenWidth = 0.0
        var cardWidth = 0.0
        @Binding var postDetailViewModel: PostDetailViewModel
        
        init(_ parent: WaterfallCollectionViewController, uiCollectionViewController: UICollectionViewController, postDetailViewModel: Binding<PostDetailViewModel>) {
            self.parent = parent
            self.uiCollectionViewController = uiCollectionViewController
            self.screenWidth = UIScreen.main.bounds.width
            self.cardWidth = (screenWidth - (Constants.postCardPadding * 3)) / 2
            self._postDetailViewModel = postDetailViewModel
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let post = parent.homeViewModel.postsData.postModels?[indexPath.item] {
                if (post.getThumbnailAspectRatio() > 0.0) {
                    let cardImageHeight = cardWidth * post.getThumbnailAspectRatio()
                    let postTitleHeight = 50.0
                    let postAuthorViewHeight = 28.0
                    let cardHeight = cardImageHeight + postTitleHeight + postAuthorViewHeight
                    return CGSize.init(width: cardWidth, height: cardHeight)
                }
            }
            //Return a default aspect ratio, if none set
            return CGSize.init(width: 200.0, height: 400.0)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            parent.homeViewModel.postsData.postModels?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageUICollectionViewCell
            // Add image to cell
            if let post = parent.homeViewModel.postsData.postModels?[indexPath.item] {
                if let imageUrl = post.imageUrls?[0] {
                    let cloudinaryCompressedUrl = CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)
                    cell.setImageUrl(urlString: cloudinaryCompressedUrl)
                } else if let imageUrl = post.imageUrl {
                    let cloudinaryCompressedUrl = CloudinaryHelper.getCompressedUrl(url: imageUrl, width: CloudinaryHelper.thumbnailWidth)
                    cell.setImageUrl(urlString: cloudinaryCompressedUrl)
                }
                cell.postTitleLabel.text = post.title
                if let authorName = post.author.displayName {
                    cell.postAuthorLabel.text = authorName
                }
                if let profilePicImageUrl = post.author.profilePicImageUrl, !profilePicImageUrl.isEmpty {
                    let cloudinaryCompressedUrl = CloudinaryHelper.getCompressedUrl(url: profilePicImageUrl, width: CloudinaryHelper.profileThumbnailWidth)
                    cell.setProfileImageUrl(urlString: cloudinaryCompressedUrl)
                }
                if let prompt = post.prompt, !prompt.promptHasAlreadyEnded() && !parent.homeViewModel.hasUserPostedToPrompt(promptId: prompt.promptId){
                    cell.setBlurAndAddPromptButton()
                } else {
                    cell.removeBlurAndAddPromptButton()
                }
                if parent.homeViewModel.hasUserLikedPost(postId: post.id ?? "noId") {
                    cell.showHighlightedApplaudButton()
                } else {
                    cell.showUnhighlighedApplaudButton()
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let post = parent.homeViewModel.postsData.postModels?[indexPath.item] {
                if let prompt = post.prompt, !prompt.promptHasAlreadyEnded() && !parent.homeViewModel.hasUserPostedToPrompt(promptId: prompt.promptId){
                    //Don't allow click if hidden/blurred
                } else {
                    postDetailViewModel = PostDetailViewModel(postModel: post)
                    parent.homeViewModel.shouldPopToRootViewIfFalse = true
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
