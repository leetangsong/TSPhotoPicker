//
//  PhotoTools.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/2.
//

import Foundation
import Photos
import Kingfisher
import Handy
public struct PhotoTools {
    /// 根据PHAsset资源获取对应的目标大小
    public static func transformTargetWidthToSize(targetWidth: CGFloat,asset: PHAsset) -> CGSize {
        let scale: CGFloat = 0.8
        let aspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        var width = targetWidth
        if asset.pixelWidth < Int(targetWidth) {
            width *= 0.5
        }
        var height = width / aspectRatio
        let maxHeight = UIScreen.main.bounds.size.height
        if height > maxHeight {
            width = maxHeight / height * width * scale
            height = maxHeight * scale
        }
        if height < targetWidth && width >= targetWidth {
            width = targetWidth / height * width * scale
            height = targetWidth * scale
        }
        return CGSize(width: width, height: height)
    }
    
    /// 转换视频时长为 mm:ss 格式的字符串
    public static func transformVideoDurationToString(
        duration: TimeInterval
    ) -> String {
        let time = Int(round(Double(duration)))
        if time<60 {
            return String.init(format: "00:%02ld", time)
        }else if  time < 3600{
            let m: Int = time/60
            let s: Int = time%60
            return String.init(format: "%02ld:%02ld", m,s)
        }else{
            let h: Int = time/3600
            let m: Int = (time%3600)/60
            let s: Int = m%60
            return String.init(format: "%02ld:%02ld:%02ld", h,m,s)
        }
    }
    /// 根据视频地址获取视频时长
    public static func getVideoDuration(videoURL: URL?) -> TimeInterval {
        guard let videoURL = videoURL else {
            return 0
        }
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
        let urlAsset = AVURLAsset.init(url: videoURL, options: options)
        //        let second = TimeInterval(urlAsset.duration.value) / TimeInterval(urlAsset.duration.timescale)
        return TimeInterval(round(urlAsset.duration.seconds))
    }
    
    /// 根据视频时长(00:00:00)获取秒
    static func getVideoTime(forVideo duration: String) -> TimeInterval {
        var m = 0
        var s = 0
        var ms = 0
        let components = duration.components(
            separatedBy: CharacterSet.init(charactersIn: ":.")
        )
        if components.count >= 2 {
            m = Int(components[0]) ?? 0
            s = Int(components[1]) ?? 0
            if components.count == 3 {
                ms = Int(components[2]) ?? 0
            }
        }else {
            s = Int(INT_MAX)
        }
        return TimeInterval(CGFloat(m * 60) + CGFloat(s) + CGFloat(ms) * 0.001)
    }
    
    /// 根据视频地址获取视频封面
    public static func getVideoThumbnailImage(videoURL: URL?,
                                              atTime: TimeInterval) -> UIImage? {
        guard let videoURL = videoURL else {
            return nil
        }
        let urlAsset = AVURLAsset(url: videoURL)
        return getVideoThumbnailImage(avAsset: urlAsset as AVAsset, atTime: atTime)
    }
    
    /// 根据视频获取视频封面
    public static func getVideoThumbnailImage(
        avAsset: AVAsset?,
        atTime: TimeInterval
    ) -> UIImage? {
        if let avAsset = avAsset{
            let assetImageGenerator = AVAssetImageGenerator.init(asset: avAsset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            assetImageGenerator.apertureMode = .encodedPixels
            do {
                let thumbnailImageRef = try assetImageGenerator.copyCGImage(
                    at: CMTime(
                        value: CMTimeValue(atTime),
                        timescale: avAsset.duration.timescale
                    ),
                    actualTime: nil
                )
                let image = UIImage.init(cgImage: thumbnailImageRef)
                return image
            } catch { }
        }
        return nil
        
    }
    /// 获视频缩略图
    @discardableResult
    public static func getVideoThumbnailImage(
        url: URL,
        atTime: TimeInterval,
        imageGenerator: ((AVAssetImageGenerator) -> Void)? = nil,
        completion: @escaping (URL, UIImage?, AVAssetImageGenerator.Result) -> Void
    ) -> AVAsset{
        let asset = AVURLAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            if asset.statusOfValue(forKey: "duration", error: nil) != .loaded {
                DispatchQueue.main.async {
                    completion(url, nil, .failed)
                }
                return
            }
            let generator = AVAssetImageGenerator.init(asset: asset)
            let time = CMTime.init(value: CMTimeValue(atTime), timescale: asset.duration.timescale)
            let array = [NSValue(time: time)]
            generator.generateCGImagesAsynchronously(forTimes: array) { (requestedTime, cgImage, actualTime, result, error) in
                if let image = cgImage, result == .succeeded {
                    var image = UIImage(cgImage: image)
                    if image.imageOrientation != .up, let img = image.handy.normalizedImage() {
                        image = img
                    }
                    DispatchQueue.main.async {
                        completion(url, image, result)
                    }
                }else {
                    DispatchQueue.main.async {
                        completion(url, nil, result)
                    }
                }
                DispatchQueue.main.async {
                    imageGenerator?(generator)
                }
            }
        }
        return asset
    }
    
#if canImport(Kingfisher)
    public static func downloadNetworkImage(
        with url: URL,
        cancelOrigianl: Bool = true,
        options: KingfisherOptionsInfo,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil
    ) {
        let key = url.cacheKey
        if ImageCache.default.isCached(forKey: key) {
            ImageCache.default.retrieveImage(
                forKey: key,
                options: options
            ) { (result) in
                switch result {
                case .success(let value):
                    completionHandler?(value.image)
                case .failure(_):
                    completionHandler?(nil)
                }
            }
            return
        }
        ImageDownloader.default.downloadImage(
            with: url,
            options: options,
            progressBlock: progressBlock
        ) { (result) in
            switch result {
            case .success(let value):
                if let gifImage = DefaultImageProcessor.default.process(
                    item: .data(value.originalData),
                    options: .init([])
                ) {
                    if cancelOrigianl {
                        ImageCache.default.store(
                            gifImage,
                            original: value.originalData,
                            forKey: key
                        )
                    }
                    completionHandler?(gifImage)
                    return
                }
                if cancelOrigianl {
                    ImageCache.default.store(
                        value.image,
                        original: value.originalData,
                        forKey: key
                    )
                }
                completionHandler?(value.image)
            case .failure(_):
                completionHandler?(nil)
            }
        }
    }
#endif
    
    
}