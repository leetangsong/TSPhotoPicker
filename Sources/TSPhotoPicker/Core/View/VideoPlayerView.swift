//
//  VideoPlayerView.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/24.
//

import UIKit
import AVKit
class VideoPlayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var avAsset: AVAsset?
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
