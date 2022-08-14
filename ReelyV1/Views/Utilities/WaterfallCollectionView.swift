//
//  WaterfallCollectionView.swift
//  FITs
//
//  Created by Andrew Pang on 8/14/22.
//

import SwiftUI

struct WaterfallCollectionView: UIViewRepresentable {
    
    var postModels: [PostModel]
    
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
        Coordinator(self)
    }

    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
        var parent: WaterfallCollectionView

        init(_ parent: WaterfallCollectionView) {
            self.parent = parent
        }
        
        func sizeOfImageAt(url: URL) -> CGSize? {
            // with CGImageSource we avoid loading the whole image into memory
            guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                return nil
            }
            
            let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
                return nil
            }
            
            if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
               let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
                return CGSize(width: width, height: height)
            } else {
                return nil
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let postModel = parent.postModels[indexPath.item]
            if let imageUrl = postModel.imageUrls?[0] {
                if let url = URL(string: imageUrl) {
                    if let size = sizeOfImageAt(url: url) {
                        return CGSize.init(width: size.width, height: size.height)
                    }
                }
            }
            return CGSize.init(width: 50, height: 100)
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
