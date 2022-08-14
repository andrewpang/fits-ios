//
//  WaterfallCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI

struct WaterfallCollectionView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let cellIdentifier = "hostCell"
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator

        // Collection view attributes
        collectionView.alwaysBounceVertical = true

        // Add the waterfall layout to your collection view
        collectionView.collectionViewLayout = layout
        
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize.init(width: 50, height: 50)
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            3
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cellIdentifier = "hostCell"
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = PostCardView(post: PostModel(author: PostAuthorMap(), title: "Title", body: "Body"))
            return hostCell!
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
                       hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                       contentView.addSubview(hostView)
                   }
               }
           }
       }
}
