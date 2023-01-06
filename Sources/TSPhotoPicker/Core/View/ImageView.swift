//
//  ImageView.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/24.
//

import UIKit
import Kingfisher
final class ImageView: UIView {

    lazy var imageView: UIImageView = {
        var imageView: UIImageView
        imageView = AnimatedImageView.init()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            setImage(newValue, animated: false)
        }
    }
    
    init() {
        super.init(frame: .zero)
        addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func setImage(_ image: UIImage?, animated: Bool) {
        if let image = image {
            imageView.image = image
            if animated {
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                imageView.layer.add(transition, forKey: nil)
            }
        }
    }
    
    func setImage(_ img: UIImage) {
        let image = DefaultImageProcessor.default.process(item: .image(img), options: .init([]))
        imageView.image = image
    }
    
    func setImageData(_ imageData: Data) {
        let image = DefaultImageProcessor.default.process(item: .data(imageData), options: .init([]))
        imageView.image = image
    }
    
    func startAnimatedImage() {
        imageView.startAnimating()
    }
    
    func stopAnimatedImage() {
        imageView.stopAnimating()
    }
    
}
