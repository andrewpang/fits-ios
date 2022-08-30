//
//  WaterfallPromptCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/24/22.
//

import SwiftUI
import Amplitude
import Mixpanel

// WARNING: When updating, check if needs to update WaterfallCollectionViewController
struct WaterfallPromptCollectionView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var promptDetailViewModel: PromptDetailViewModel
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
//        if (homeViewModel.shouldScrollToTop) {
//            uiViewController.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
//                                              at: .top,
//                                        animated: true)
//            homeViewModel.shouldScrollToTop = false
//        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, uiCollectionViewController: uiCollectionViewController, postDetailViewModel: $selectedPostDetail)
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        var parent: WaterfallPromptCollectionView
        var uiCollectionViewController: UICollectionViewController
        var screenWidth = 0.0
        var cardWidth = 0.0
        @Binding var postDetailViewModel: PostDetailViewModel
        
        init(_ parent: WaterfallPromptCollectionView, uiCollectionViewController: UICollectionViewController, postDetailViewModel: Binding<PostDetailViewModel>) {
            self.parent = parent
            self.uiCollectionViewController = uiCollectionViewController
            self.screenWidth = UIScreen.main.bounds.width
            self.cardWidth = (screenWidth - (Constants.postCardPadding * 3)) / 2
            self._postDetailViewModel = postDetailViewModel
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let post = parent.promptDetailViewModel.postsData.postModels?[indexPath.item] {
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
            parent.promptDetailViewModel.postsData.postModels?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageUICollectionViewCell
            // Add image to cell
            if let post = parent.promptDetailViewModel.postsData.postModels?[indexPath.item] {
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
                if parent.promptDetailViewModel.hasUserLikedPost(postId: post.id ?? "noId") {
                    cell.showHighlightedApplaudButton()
                    cell.applaudButtonTapAction = {
                        () in
                        self.parent.promptDetailViewModel.unlikePost(postModel: post, userId: self.parent.authenticationViewModel.userModel?.id)
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                        let eventName = "Like Button - Clicked"
                        let propertiesDict = ["isLike": false as Bool, "source": "promptFeed"] as? [String : Any]
                        let mixpanelDict = ["isLike": false as Bool, "source": "promptFeed"] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }
                } else {
                    cell.showUnhighlighedApplaudButton()
                    cell.applaudButtonTapAction = {
                        () in
                        self.parent.promptDetailViewModel.likePost(postModel: post, likeModel: LikeModel(id: self.parent.authenticationViewModel.userModel?.id, author: self.parent.authenticationViewModel.getPostAuthorMap()))
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        let eventName = "Like Button - Clicked"
                        let propertiesDict = ["isLike": true as Bool, "source": "promptFeed"] as? [String : Any]
                        let mixpanelDict = ["isLike": true as Bool, "source": "promptFeed"] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }
                }
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let post = parent.promptDetailViewModel.postsData.postModels?[indexPath.item] {
                postDetailViewModel = PostDetailViewModel(postModel: post)
                parent.promptDetailViewModel.detailViewIsActive = true
            }
        }
    }
}
