//
//  WaterfallCollectionRandomFeedView.swift
//  FITs
//
//  Created by Andrew Pang on 9/18/22.
//

import SwiftUI
import Amplitude
import Mixpanel

// WARNING: When updating, check if needs to update WaterfallCollectionViewController, WaterfallPromptCollectionView
struct RandomFeedWaterfallCollectionView: UIViewControllerRepresentable {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var tabViewModel: TabViewModel
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
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        let uiAction = UIAction(handler: { uiAction in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   homeViewModel.refreshRandomFeed()
                   refreshControl.endRefreshing()
            }
            let eventName = "Home Feed Refresh - Pulled"
            let propertiesDict = ["feed": "Random"] as? [String : String]
            Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
            Mixpanel.mainInstance().track(event: eventName, properties: propertiesDict)
        })
        refreshControl.addAction(uiAction, for: .primaryActionTriggered)
        
        return uiCollectionViewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: Context) {
        //TODO: Look into if there's a more perfomant way to handle this
        uiViewController.collectionView.reloadData()
        if (homeViewModel.shouldScrollToTopForYou) {
            uiViewController.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                              at: .top,
                                        animated: true)
            homeViewModel.shouldScrollToTopForYou = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, uiCollectionViewController: uiCollectionViewController, postDetailViewModel: $selectedPostDetail)
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        var parent: RandomFeedWaterfallCollectionView
        var uiCollectionViewController: UICollectionViewController
        var screenWidth = 0.0
        var cardWidth = 0.0
        @Binding var postDetailViewModel: PostDetailViewModel
        
        init(_ parent: RandomFeedWaterfallCollectionView, uiCollectionViewController: UICollectionViewController, postDetailViewModel: Binding<PostDetailViewModel>) {
            self.parent = parent
            self.uiCollectionViewController = uiCollectionViewController
            self.screenWidth = UIScreen.main.bounds.width
            self.cardWidth = (screenWidth - (Constants.postCardPadding * 3)) / 2
            self._postDetailViewModel = postDetailViewModel
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let post = parent.homeViewModel.randomizedPostsData.postModels?[indexPath.item] {
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
            parent.homeViewModel.randomizedPostsData.postModels?.count ?? 0
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageUICollectionViewCell
            // Add image to cell
            if let post = parent.homeViewModel.randomizedPostsData.postModels?[indexPath.item] {
                if let imageUrls = post.imageUrls, !imageUrls.isEmpty {
                    let cloudinaryCompressedUrl = CloudinaryHelper.getCompressedUrl(url: imageUrls.first!, width: CloudinaryHelper.thumbnailWidth)
                    cell.setImageUrl(urlString: cloudinaryCompressedUrl)
                    if (imageUrls.count > 1) {
                        cell.showMultiPhotoIcon()
                    } else {
                        cell.hideMultiPhotoIcon()
                    }
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
                    cell.applaudButtonTapAction = {
                        () in
                        self.parent.homeViewModel.unlikePost(postModel: post, userId: self.parent.authenticationViewModel.userModel?.id)
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.error)
                        let eventName = "Like Button - Clicked"
                        let propertiesDict = ["isLike": false as Bool, "source": "homeFeed", "postId": post.id ?? "noId"] as? [String : Any]
                        let mixpanelDict = ["isLike": false as Bool, "source": "homeFeed", "postId": post.id ?? "noId"] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }
                } else {
                    cell.showUnhighlighedApplaudButton()
                    cell.applaudButtonTapAction = {
                        () in
                        self.parent.homeViewModel.likePost(postModel: post, likeModel: LikeModel(id: self.parent.authenticationViewModel.userModel?.id, author: self.parent.authenticationViewModel.getPostAuthorMap()))
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        let eventName = "Like Button - Clicked"
                        let propertiesDict = ["isLike": true as Bool, "source": "homeFeed", "postId": post.id ?? "noId"] as? [String : Any]
                        let mixpanelDict = ["isLike": true as Bool, "source": "homeFeed", "postId": post.id ?? "noId"] as? [String : MixpanelType]
                        Amplitude.instance().logEvent(eventName, withEventProperties: propertiesDict)
                        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelDict)
                    }
                }
                
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let post = parent.homeViewModel.randomizedPostsData.postModels?[indexPath.item] {
                if let prompt = post.prompt, !prompt.promptHasAlreadyEnded() && !parent.homeViewModel.hasUserPostedToPrompt(promptId: prompt.promptId){
                    parent.tabViewModel.showPromptTab()
                } else {
                    postDetailViewModel = PostDetailViewModel(postModel: post)
                    parent.homeViewModel.shouldPopToRootViewIfFalse = true
                }
            }
        }
    }
}
