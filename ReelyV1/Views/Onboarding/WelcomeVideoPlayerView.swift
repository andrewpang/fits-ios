//
//  WelcomeVideoPlayerView.swift
//  FITs
//
//  Created by Andrew Pang on 7/7/22.
//

import SwiftUI
import AVKit
import AVFoundation

let videoName = "pexels-runway"

struct WelcomeVideoPlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WelcomeVideoPlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}


class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Load the resource -> h
//        let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
        let videoUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/reelyv1.appspot.com/o/appImages%2FFITsWelcomeCompressed.mp4?alt=media&token=8f49b09b-9652-410c-85db-5cd5f0fc5472")!
        let asset = AVAsset(url: videoUrl)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        player.isMuted = true
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.isOtherAudioPlaying {
            _ = try? audioSession.setCategory(AVAudioSession.Category.ambient, options: AVAudioSession.CategoryOptions.mixWithOthers)
        }
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        // Start the movie
        player.play()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
