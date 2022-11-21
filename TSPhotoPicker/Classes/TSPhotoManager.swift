//
//  TSPhotoManager.swift
//  Pods
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Photos
import CoreGraphics
import CoreServices
import Handy
private var AssetGridThumbnailSize: CGSize = .zero
private var TSScreenScale: CGFloat = 0
private var TSScreenWidth: CGFloat = 0

class TSPhotoManager: NSObject {
    static let shared = TSPhotoManager()
    
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    var sortAscending: Bool = true
    var shouldFixOrientation: Bool = false
    var isPreviewNetworkImage: Bool = false
    var photoPreviewMaxWidth: CGFloat = 600
    var presetName = AVAssetExportPresetMediumQuality
    var photoWidth: CGFloat = 824{
        didSet{
            TSScreenWidth = photoWidth/2
        }
    }
    var columnNumber: Int = 4{
        didSet{
            configTSScreenWidth()
            let margin: CGFloat = 4
            let itemWH = (TSScreenWidth - 2 * margin - 4) / CGFloat(columnNumber) - margin
            
            AssetGridThumbnailSize = CGSize.init(width: itemWH * TSScreenScale, height: itemWH * TSScreenScale)
        }
    }
    
    
    
    func isVideo(asset: PHAsset) -> Bool{
        return asset.mediaType == .video
    }
    func isAssetCannotBeSelected(asset: PHAsset) -> Bool{
        //        if let result = self.pickerDelegate?.isAssetCanBeSelected?(asset: asset, type: TSPhotoManager.shared.transformAssetType(asset: asset)){
        //            return !result
        //        }
        
        return false
    }
    ///取消加载
    func cancelImageRequest(_ requestID: PHImageRequestID){
        PHImageManager.default().cancelImageRequest(requestID)
        PHCachingImageManager.default().cancelImageRequest(requestID)
    }
    // MARK: - 获取相册
    /// 获取相机胶卷相册
    /// - Parameters:
    ///   - needFetchAssets: 是否需要获取里面的图片/视频数据
    func getCameraRollAlbum(needFetchAssets: Bool, completion:((_ model: TSAlbumModel)->Void)? = nil){
        let config = TSPhotoPickerConfig.shared
        let option = PHFetchOptions()
        if  !config.allowSelectVideo {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        }
        if  !config.allowSelectImage {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
        }
        
        if !sortAscending{
            option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: sortAscending)]
        }
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        smartAlbums.enumerateObjects { (collection, index, stop) in
            if !collection.isKind(of: PHAssetCollection.self){
                return
            }
            ///过滤空相册
            if collection.estimatedAssetCount <= 0{
                return
            }
            if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                let result = PHAsset.fetchAssets(in: collection, options: option)
                let model = self.getAlbumModel(with: result, collection: collection, isCameraRoll: true, needFetchAssets: needFetchAssets, options: option)
                completion?(model)
                stop.pointee = true
            }
        }
        
    }
    
    ///获取所有相册
    func getAllAlbums(needFetchAssets: Bool, completion:((_ albums: [TSAlbumModel])->Void)? = nil){
        let config = TSPhotoPickerConfig.shared
        let option = PHFetchOptions()
        if  !config.allowSelectVideo {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        }
        if  !config.allowSelectImage {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
        }
        if config.allowSelectVideo && config.allowSelectImage  {
            option.predicate = nil
        }
        
        if !sortAscending{
            option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: sortAscending)]
        }
        
        ///获取智能相册
        //        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
        //        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.any, options: nil)
        let myPhotoStreamAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumMyPhotoStream, options: nil)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumSyncedAlbum, options: nil)
        let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumCloudShared, options: nil)
        let arrAlbums: [PHFetchResult<PHAssetCollection>] = [myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums]
        var albums: [TSAlbumModel] = []
        
        for result in arrAlbums{
            result.enumerateObjects({ (collection, index, stop) in
                if !collection.isKind(of: PHAssetCollection.self){
                    return
                }
                //过滤空相册
                if collection.estimatedAssetCount <= 0, collection.assetCollectionSubtype != .smartAlbumUserLibrary {
                    return
                }
                let fetchResult = PHAsset.fetchAssets(in: collection, options: option)
                if fetchResult.count < 1, collection.assetCollectionSubtype != .smartAlbumUserLibrary {
                    return
                }
                //                if collection.assetCollectionSubtype.rawValue == 215 { return }
                //                if collection.assetCollectionSubtype.rawValue == 212 { return }
                //                if collection.assetCollectionSubtype.rawValue == 204 { return }
                if collection.assetCollectionSubtype.rawValue == 1000000201 { return }
                if collection.assetCollectionSubtype == .smartAlbumAllHidden { return }
                //获取相册内asset result
                if collection.assetCollectionSubtype == .smartAlbumUserLibrary{
                    let model = self.getAlbumModel(with: fetchResult, collection: collection, isCameraRoll: true, needFetchAssets: needFetchAssets, options: option)
                    albums.insert(model, at: 0)
                }else{
                    let model = self.getAlbumModel(with: fetchResult, collection: collection, isCameraRoll: false, needFetchAssets: needFetchAssets, options: option)
                    albums.append(model)
                }
            })
        }
        completion?(albums)
        
    }
    
    /// 获取live photo
    @discardableResult
    @available(iOS 9.1, *)
    func requestLivePhotoImage(for asset: PHAsset,
                                     completion: ((_ livePhoto: PHLivePhoto?,_ info: [AnyHashable: Any]?)->Void)?) -> PHImageRequestID{
        let option = PHLivePhotoRequestOptions()
        option.version = .current
        option.deliveryMode = .opportunistic
        option.isNetworkAccessAllowed = true
        
        return PHImageManager.default().requestLivePhoto(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (livePhoto, info) in
            completion?(livePhoto,info)
        }
    }
    // MARK: - 获取照片
    @discardableResult
    func getPhoto(with asset: PHAsset, photoWidth: CGFloat = TSScreenWidth, resizeMode: PHImageRequestOptionsResizeMode = .fast, networkAccessAllowed: Bool = true , progressHandler: PHAssetImageProgressHandler?  = nil, completion: ((_ photo: UIImage?, _ info: [AnyHashable: Any]?, _ isDegraded: Bool)->Void)? = nil) -> PHImageRequestID{
        
        var imageSize: CGSize = .zero
        if photoWidth < TSScreenWidth && photoWidth < photoPreviewMaxWidth {
            imageSize = AssetGridThumbnailSize
        }else{
            let aspectRatio = CGFloat(asset.pixelHeight)/CGFloat(asset.pixelWidth)
            var pixelWidth = photoWidth * TSScreenScale
            // 超宽图片
            if aspectRatio > 1.8 {
                pixelWidth = pixelWidth * aspectRatio
            }
            // 超高图片
            if aspectRatio < 0.2 {
                pixelWidth = pixelWidth * 0.5
            }
            let pixelHeight = pixelWidth * aspectRatio
            imageSize = CGSize.init(width: pixelWidth, height: pixelHeight)
        }
        
        let option = PHImageRequestOptions()
        option.resizeMode = resizeMode
        let imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: option) { result, info in
            let cancelled = info?[PHImageCancelledKey] as? Bool ?? false
            var image = result
            if !cancelled && result != nil {
                image = self.fixOrientation(image: result!)
                let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool ?? false
                completion?(image, info, isDegraded)
            }
            
            if info?[PHImageResultIsInCloudKey] != nil && result == nil && networkAccessAllowed {
                let option = PHImageRequestOptions()
                option.resizeMode = resizeMode
                option.isNetworkAccessAllowed = true
                option.progressHandler = { (progress, error, stop, info) in
                    DispatchQueue.main.async {
                        progressHandler?(progress, error, stop, info)
                    }
                }
                PHImageManager.default().requestImageData(for: asset, options: option) { imageData, dataUTI, orientation, info in
                    var resultImage: UIImage?
                    if let data = imageData{
                        resultImage = UIImage.init(data: data)
                        if !TSPhotoPickerConfig.shared.notScaleImage {
                            resultImage = self.scale(image: resultImage!, to: imageSize)
                        }
                        resultImage = self.fixOrientation(image: resultImage)
                    }
                    
                    completion?(resultImage, info, false)
                    
                }
            }
        }
        
        return imageRequestID
    }
    // 获取封面图
    @discardableResult
    func getPostImage(with albumModel: TSAlbumModel, completion: ((_ image: UIImage?)->Void)? = nil)-> Int32{
        var asset = albumModel.result?.lastObject
        if !sortAscending {
            asset = albumModel.result?.firstObject
        }
        if asset == nil {
            return -1
        }
        
        return getPhoto(with: asset!, photoWidth: 80, completion:  { photo, info, isDegraded in
            completion?(photo)
        })
    }
    
    //获取原图
    @discardableResult
    func getOriginalPhoto(with asset: PHAsset, progressHandler: PHAssetImageProgressHandler?  = nil, completion: ((_ photo: UIImage?, _ info: [AnyHashable: Any]?, _ isDegraded: Bool)->Void)? = nil )-> Int32{
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = true
        option.progressHandler = progressHandler
        
        return PHImageManager.default().requestImageData(for: asset, options: option) { imageData, dataUTI, orientation, info in
            let cancelled = info?[PHImageCancelledKey] as? Bool ?? false
            if cancelled == false , imageData != nil, let image = UIImage.init(data: imageData!) {
                let result = self.fixOrientation(image: image)
                let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool ?? false
                completion?(result, info, isDegraded)
            }
        }
    }
    
    @discardableResult
    func getOriginalPhotoData(with asset: PHAsset, progressHandler: PHAssetImageProgressHandler?  = nil, completion: ((_ data: Data?, _ info: [AnyHashable: Any]?, _ isDegraded: Bool)->Void)? = nil )-> Int32{
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        if (asset.value(forKey: "filename") as? String)?.hasSuffix("GIF") == true{
            option.version = .original
        }
        option.isNetworkAccessAllowed = true
        option.progressHandler = progressHandler
        
        return PHImageManager.default().requestImageData(for: asset, options: option) { imageData, dataUTI, orientation, info in
            let cancelled = info?[PHImageCancelledKey] as? Bool ?? false
            if cancelled == false , imageData != nil {
                let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool ?? false
                completion?(imageData, info, isDegraded)
            }
        }
    }
    // MARK: - 获取视频
    func getVideo(with asset: PHAsset, progressHandler: PHAssetImageProgressHandler?  = nil, completion: ((_ item: AVPlayerItem?, _ info: [AnyHashable: Any]?)->Void)? = nil){
        let option = PHVideoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.progressHandler = { (progress, error, stop, info) in
            DispatchQueue.main.async {
                progressHandler?(progress, error, stop, info)
            }
        }
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: option) { item, info in
            completion?(item, info)
        }
    }
    
    func getImage(with videoURL: URL) -> UIImage?{
        let asset = AVURLAsset.init(url: videoURL)
        let generator = AVAssetImageGenerator.init(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.apertureMode = .encodedPixels
        if let imageRef = try? generator.copyCGImage(at: CMTimeMake(value: 0, timescale: 60), actualTime: nil){
            let image = UIImage.init(cgImage: imageRef)
            return image
        }
        return nil
    }
    
    //MARK:- 保存图片
    
    /// 保存图片
    /// - Parameters:
    ///   - image: 图片
    ///   - meta: 有值就  根据路径去保存图片
    ///   - location: 定位
    func saveImage(toAblum image: UIImage, meta:[AnyHashable: Any]? = nil, location: CLLocation? = nil, completion: ((_ asset: PHAsset?, _ error: Error?)->Void)?){
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            completion?(nil,nil)
        }else {
            var localIdentifier: String?
            
            var path: String?
            var tmpURL: URL?
            if meta != nil, let imageData = image.jpegData(compressionQuality: 1) {
                
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd-HH:mm:ss-SSS"
                path = NSTemporaryDirectory().appendingFormat("image-%@.jpg", formater.string(from: Date()))
                tmpURL = URL.init(fileURLWithPath: path!)
                if let destination = CGImageDestinationCreateWithURL(tmpURL! as CFURL, kUTTypeJPEG, 1, meta! as CFDictionary), let source = CGImageSourceCreateWithData(imageData as CFData, nil){
                    CGImageDestinationAddImageFromSource(destination, source, 0, meta! as CFDictionary)
                    CGImageDestinationFinalize(destination)
                }
            }
            
            PHPhotoLibrary.shared().performChanges({
                var request: PHAssetChangeRequest? = PHAssetChangeRequest.creationRequestForAsset(from: image)
                if tmpURL != nil {
                    request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: tmpURL!)
                }
                request?.location = location
                request?.creationDate = Date()
                localIdentifier = request?.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { (success, error) in
                if let _path = path{
                   try? FileManager.default.removeItem(atPath: _path)
                }
                if success && localIdentifier != nil {
                    self.fetchAsset(by: localIdentifier!, retryCount: 10, completion: completion)
                }else{
                    completion?(nil,error)
                    print("保存照片出错:\(error?.localizedDescription ?? "")")
                    return
                }
            })
        }
    }
    //MARK:- 保存视频到系统相册
    func saveVideo(url: URL, location: CLLocation? = nil, completion: ((_ asset: PHAsset?, _ error: Error?)->Void)? = nil){
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            completion?(nil,nil)
        }else {
            var localIdentifier: String?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:url)
                request?.location = location
                request?.creationDate = Date()
                localIdentifier = request?.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { (success, error) in
                if success && localIdentifier != nil {
                    self.fetchAsset(by: localIdentifier!, retryCount: 10, completion: completion)
                }else{
                    completion?(nil,error)
                    print("保存视频出错:\(error?.localizedDescription ?? "")")
                    return
                }
            })
        }
    }
    // MARK: -导出视频
    func getVideoOutputPath(asset: PHAsset, presetName: String = AVAssetExportPresetMediumQuality, timeRange: CMTimeRange = .zero,success: ((_ outputPath: String)->Void)? = nil, fail: ((_ errorMessage: String?, _ error: Error?)->Void)? = nil){
        if #available(iOS 14.0, *) {
            requestVideoOutputPath(asset: asset, presetName: presetName, timeRange: timeRange, success: success, fail: fail)
            return
        }
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: getVideoRequestOptions()) { avasset, audioMix, info in
            if let videoAsset = avasset as? AVURLAsset {
                self.startExportVideoOutputPath(videoAsset: videoAsset, presetName: presetName, timeRange: timeRange, success: success, fail: fail)
            }
        }
    }
    func requestVideoOutputPath(asset: PHAsset, presetName: String = AVAssetExportPresetMediumQuality, timeRange: CMTimeRange = .zero, success: ((_ outputPath: String)->Void)? = nil, fail: ((_ errorMessage: String?, _ error: Error?)->Void)? = nil){
        PHImageManager.default().requestExportSession(forVideo: asset, options: getVideoRequestOptions(), exportPreset: presetName) { exportSession, info in
            let outputPath = self.getVideoOutputPath()
            exportSession?.outputURL = URL.init(fileURLWithPath: outputPath)
            exportSession?.shouldOptimizeForNetworkUse = false
            exportSession?.outputFileType = .mp4
            if !CMTimeRangeEqual(timeRange, .zero) {
                exportSession?.timeRange = timeRange
            }
            exportSession?.exportAsynchronously(completionHandler: {
                self.handleVideoExportResult(session: exportSession!, outputPath: outputPath, success: success, fail: fail)
            })
        }
    }
    
    
    ///获取视频地址
    func requestVideoURL(with asset: PHAsset, success: ((_ videoURL: URL)->Void)? = nil, fail:((_ info: [AnyHashable: Any]?)->Void)? = nil){
        PHImageManager.default().requestAVAsset(forVideo: asset, options: getVideoRequestOptions()) { avasset, audioMix, info in
            if let videoAsset = avasset as? AVURLAsset {
                let url = videoAsset.url
                success?(url)
            }else{
                fail?(info)
            }
            
        }
    }
    /// 将系统的转换成自定义的type
    func transformAssetType(asset: PHAsset)->TSPhotoModelMediaType{
        switch asset.mediaType {
        case .audio:
            return TSPhotoModelMediaType.audio
        case .video:
            return TSPhotoModelMediaType.video
        case .image:
            if (asset.value(forKey: "filename") as? String)?.hasSuffix("GIF") == true{
                return TSPhotoModelMediaType.gif
            }
            if #available(iOS 9.1, *){
                if asset.mediaSubtypes == .photoLive{
                    return TSPhotoModelMediaType.livePhoto
                }
            }
            
            
            if asset.mediaSubtypes.rawValue == 10 || asset.mediaSubtypes.rawValue == 520{
                return TSPhotoModelMediaType.livePhoto
            }
            
            
            return TSPhotoModelMediaType.photo
        default:
            return TSPhotoModelMediaType.unknown
        }
    }
    
    // MARK: -  权限
    func authorizationStatusAuthorized(complete: (()->Void)? = nil) -> Bool{
        if isPreviewNetworkImage {
            return true
        }
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.notDetermined {
            requestAuthorization(completion: complete)
        }
        return status == PHAuthorizationStatus.authorized
    }
    
    func requestAuthorization(completion: (()->Void)? = nil ){
        DispatchQueue.global().async {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    func isPHAuthorizationStatusLimited() -> Bool{
        if #available(iOS 14,*){
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if status == .limited {
                return true
            }
        }
        return false
    }
    ///缩放图片至新尺寸
    func scale(image: UIImage, to size: CGSize) -> UIImage{
        if image.size.width>size.width {
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect.init(origin: .zero, size: size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? image
        }else{
            return image
        }
    }
    
    
    func createModel(with asset: PHAsset) -> TSPhotoModel{
        let timeLength = getDuration(asset: asset)
        return TSPhotoModel.init(asset: asset, timeLength: timeLength)
    }
    
    //获得相册照片列表model
    func getAssetModel(from fetchResult: PHFetchResult<PHAsset>, completion:((_ models: [TSPhotoModel])->Void)? = nil){
        let config = TSPhotoPickerConfig.shared
        
        var models: [TSPhotoModel] = []
        
        fetchResult.enumerateObjects { (asset, index, stop) in
            let type = self.transformAssetType(asset: asset)
            if type == .photo && !config.allowSelectImage{
                return
            }
            if type == .gif && !config.allowSelectGif{
                return
            }
            if type == .video && !config.allowSelectVideo{
                return
            }
            
            let duration = self.getDuration(asset: asset)
            models.append(TSPhotoModel.init(asset: asset, timeLength: duration))
            
        }
        completion?(models)
    }
    /// 获得一组照片的大小
    func getPhotosBytes(with photos: [TSPhotoModel], completion:((_ totalBytes: String)->Void)? = nil){
        if photos.count == 0 {
            completion?("0B")
            return
        }
        var dataLength: Int64 = 0
        var assetCount = 0
        for model in photos {
            let options = PHImageRequestOptions()
            options.resizeMode = .fast
            options.isNetworkAccessAllowed = true
            if model.type == .gif {
                options.version = .original
            }
            if model.type == .video {
                let option = PHVideoRequestOptions()
                option.isNetworkAccessAllowed = true
                option.version = .original
                PHImageManager.default().requestAVAsset(forVideo: model.asset!, options: option) { asset, audioMix, info in
                    if let avasset = asset as? AVURLAsset {
                        var size: Int64 = 0
                        let sizePointer = withUnsafeMutablePointer(to: &size) { pointer in
                            return AutoreleasingUnsafeMutablePointer<AnyObject?>.init(pointer)
                        }
                        try? (avasset.url as NSURL).getResourceValue(sizePointer, forKey: .fileSizeKey)
                        dataLength += (sizePointer.pointee as? Int64 ?? 0)
                        assetCount += 1
                        if assetCount >= photos.count {
                            let bytes = self.getBytes(from: dataLength)
                            completion?(bytes)
                        }
                    }
                }
            }else{
                PHImageManager.default().requestImageData(for: model.asset!, options: options) { imageData, dataUTI, orientation, info in
                    dataLength += Int64((imageData?.count ?? 0))
                    assetCount += 1
                    if assetCount >= photos.count {
                        let bytes = self.getBytes(from: dataLength)
                        completion?(bytes)
                    }
                }
            }
            
        }
        
    }
    
    
    //MARK: - 私有方法
    private func startExportVideoOutputPath(videoAsset: AVURLAsset, presetName: String = AVAssetExportPresetMediumQuality, timeRange: CMTimeRange = .zero,success: ((_ outputPath: String)->Void)? = nil, fail: ((_ errorMessage: String?, _ error: Error?)->Void)? = nil){
        let presets = AVAssetExportSession.exportPresets(compatibleWith: videoAsset)
        if presets.contains(presetName) {
            let session = AVAssetExportSession.init(asset: videoAsset, presetName: presetName)
            var outputPath = getVideoOutputPath()
            session?.shouldOptimizeForNetworkUse = false
            if !CMTimeRangeEqual(timeRange, .zero) {
                session?.timeRange = timeRange
            }
            
            let supportedTypeArray = session?.supportedFileTypes ?? []
            if supportedTypeArray.contains(.mp4){
                session?.outputFileType = .mp4
            }else if supportedTypeArray.count == 0{
                fail?("该视频类型暂不支持导出", nil)
                print("视频类型暂不支持导出")
                return
            }else{
                session?.outputFileType = supportedTypeArray.first
                outputPath = outputPath.replacingOccurrences(of: ".mp4", with: "-\(videoAsset.url.lastPathComponent)")
            }
            session?.outputURL = URL.init(fileURLWithPath: outputPath)
            let path = NSHomeDirectory().appending("/tmp")
            if !FileManager.default.fileExists(atPath: path) {
               try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            
            if TSPhotoPickerConfig.shared.needFixComposition {
                let videoComposition = fixedComposition(with: videoAsset)
                if videoComposition.renderSize.width > 0 {
                    // 修正视频转向
                    session?.videoComposition = videoComposition
                }
            }
            
            session?.exportAsynchronously(completionHandler: {
                self.handleVideoExportResult(session: session!, outputPath: outputPath, success: success, fail: fail)
            })
        }else{
            fail?("当前设备不支持该预设\(presetName)", nil)
        }
    }
    
    
    private func fixedComposition(with videoAsset: AVAsset) -> AVMutableVideoComposition{
        let videoComposition = AVMutableVideoComposition()
        let degress = degressFromVideoFile(with: videoAsset)
        if degress != 0 {
            var translateToCenter: CGAffineTransform?
            var mixedTransform: CGAffineTransform?
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            let tracks = videoAsset.tracks(withMediaType: .video)
            guard  let videoTrack = tracks.first else{
                return videoComposition
            }
            
            let roateInstruction = AVMutableVideoCompositionInstruction()
            roateInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: videoAsset.duration)
            let roateLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack)
            if degress == 90 {
                // 顺时针旋转90°
                translateToCenter = CGAffineTransform.init(translationX: videoTrack.naturalSize.height, y: 0)
                mixedTransform = translateToCenter?.rotated(by: Double.pi/2)
                videoComposition.renderSize = CGSize.init(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
                roateLayerInstruction.setTransform(mixedTransform!, at: .zero)
            }else if degress == 180 {
                // 顺时针旋转180°
                translateToCenter = CGAffineTransform.init(translationX: videoTrack.naturalSize.width, y: videoTrack.naturalSize.height)
                mixedTransform = translateToCenter?.rotated(by: Double.pi)
                videoComposition.renderSize = CGSize.init(width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height)
                roateLayerInstruction.setTransform(mixedTransform!, at: .zero)
            }else if degress == 270 {
                // 顺时针旋转270°
                translateToCenter = CGAffineTransform.init(translationX: 0, y: videoTrack.naturalSize.width)
                mixedTransform = translateToCenter?.rotated(by: Double.pi/2*3)
                videoComposition.renderSize = CGSize.init(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.width)
                roateLayerInstruction.setTransform(mixedTransform!, at: .zero)
            }
            
            roateInstruction.layerInstructions = [roateLayerInstruction]
            // 加入视频方向信息
            videoComposition.instructions = [roateInstruction]
        }
        return videoComposition
    }
    
    
    private func getVideoOutputPath() -> String{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd-HH:mm:ss-SSS"
        let path = NSHomeDirectory().appendingFormat("/tmp/video-%@-%d.mp4", formater.string(from: Date()), arc4random_uniform(10000000))
        return path
    }
    
    private func getVideoRequestOptions() -> PHVideoRequestOptions{
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .automatic
        return options
    }
    
    
    private func handleVideoExportResult(session: AVAssetExportSession, outputPath: String, success: ((_ outputPath: String)->Void)? = nil, fail: ((_ errorMessage: String?, _ error: Error?)->Void)? = nil){
        DispatchQueue.main.async {
            switch session.status {
            case .unknown:
                print("AVAssetExportSession.Status.unknown")
                break
            case .waiting:
                print("AVAssetExportSession.Status.waiting")
                break
            case .exporting:
                print("AVAssetExportSession.Status.exporting")
                break
            case .completed:
                print("AVAssetExportSession.Status.completed")
                success?(outputPath)
                break
            case .failed:
                print("AVAssetExportSession.Status.failed")
                fail?("视频导出失败", session.error)
                break
            case .cancelled:
                print("AVAssetExportSession.Status.cancelled")
                fail?("导出任务已被取消", session.error)
                break
            default:
                break
            }
        }
    }
    private func getBytes(from dataLength: Int64) -> String{
        var bytes = ""
        if Double(dataLength) >= 0.1*(1024 * 1024) {
            bytes = String.init(format: "%0.1fM", Double(dataLength)/1024/1024.0)
        }else if Double(dataLength) >= 0.1*(1024 * 1024) {
            bytes = String.init(format: "%0.0fM", Double(dataLength)/1024)
        }else{
            bytes = String.init(format: "%zdB", dataLength)
        }
        return bytes
    }
    
    ///相册模型
    private func getAlbumModel(with result: PHFetchResult<PHAsset>, collection: PHAssetCollection, isCameraRoll: Bool, needFetchAssets: Bool, options: PHFetchOptions) -> TSAlbumModel{
        let model = TSAlbumModel()
        model.isCameraRoll = isCameraRoll
        model.collection = collection
        model.setResult(result, needFetchAssets: needFetchAssets)
        model.name = collection.localizedTitle
        model.options = options
        model.count = result.count
        return model
        
    }
    private func configTSScreenWidth(){
        TSScreenWidth = UIScreen.main.bounds.size.width
        TSScreenScale = 2.0
        if TSScreenWidth>700 {
            TSScreenScale = 1.5
        }
    }
    private func getDuration(asset: PHAsset)->String?{
        if asset.mediaType != .video {
            return nil
        }
        let duration = Int(round(asset.duration))
        if duration<60 {
            return String.init(format: "00:%02ld", duration)
        }else if  duration < 3600{
            let m: Int = duration/60
            let s: Int = duration%60
            return String.init(format: "%02ld:%02ld", m,s)
        }else{
            let h: Int = duration/3600
            let m: Int = (duration%3600)/60
            let s: Int = m%60
            return String.init(format: "%02ld:%02ld:%02ld", h,m,s)
        }
    }
    
    private func getAsset(from localIdentifier: String?)->PHAsset?{
        if localIdentifier == nil {
            print("Cannot get asset from localID because it is nil")
            return nil
        }
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier!], options: nil)
        
        return result.firstObject
    }
    
    ///获取自定义相册
    private func getDestinationCollection()->PHAssetCollection?{
        //找是否已经创建自定义相册
        let collectionResult =  PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        var collection: PHAssetCollection?
        
        collectionResult.enumerateObjects { (coll, index, _) in
            if coll.localizedTitle == HandyApp.appName{
                collection = coll
            }
        }
        //创建自定义相册
        if collection == nil {
            var collectionId: String?
            PHPhotoLibrary.shared().performChanges({
                collectionId =  PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: HandyApp.appName).placeholderForCreatedAssetCollection.localIdentifier
                if let collectionId = collectionId{
                    collection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionId], options: nil).firstObject
                }
            }, completionHandler: { success, error in
                if success {
                    
                }else if error != nil{
                    print("创建相册失败:\(error!.localizedDescription)")
                }
            })
            
        }
        
        return collection
    }
    
    private func fetchAsset(by localIdentifier: String, retryCount: Int, completion:((_ asset: PHAsset?, _ error: Error?)->Void)? = nil){
        let asset = self.getAsset(from: localIdentifier)
        if asset != nil || retryCount <= 0 {
            if asset != nil , TSPhotoPickerConfig.shared.isSaveToAPPAlbum{
                let desCollection = self.getDestinationCollection()
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCollectionChangeRequest.init(for: desCollection!)?.addAssets(NSArray.init(array: [asset!]))
                }, completionHandler: { (success, error) in
                    completion?(asset, nil)
                })
            }else{
                completion?(asset, nil)
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.fetchAsset(by: localIdentifier, retryCount: retryCount-1, completion: completion)
        }
        
    }
    // 获取视频角度
    private func degressFromVideoFile(with asset: AVAsset) -> Int{
        var degress = 0
        let tracks = asset.tracks(withMediaType: .video)
        if tracks.count > 0, let videoTrack = tracks.first {
            let t = videoTrack.preferredTransform
            if t.a == 0, t.b == 1, t.c == -1, t.d == 0 {
                degress = 90
            }else if t.a == 0, t.b == -1, t.c == 1, t.d == 0 {
                degress = 270
            }else if t.a == 1, t.b == 0, t.c == 0, t.d == 1 {
                degress = 0
            }else if t.a == -1, t.b == 0, t.c == 0, t.d == -1 {
                degress = 180
            }
        }
        return degress
    }
    //修正图片转向
    private func fixOrientation(image: UIImage?) -> UIImage?{
        if image == nil {
            return nil
        }
        if !shouldFixOrientation{
            return image
        }
        
        if image!.imageOrientation == .up{
            return image
        }
        
        var transform = CGAffineTransform.identity
        switch image!.imageOrientation {
        case .down, .downMirrored:
            transform = CGAffineTransform.init(translationX: image!.size.width, y: image!.size.height)
            transform = CGAffineTransform.init(rotationAngle: Double.pi)
            break
        case .left, .leftMirrored:
            transform = CGAffineTransform.init(translationX: image!.size.width, y: 0)
            transform = CGAffineTransform.init(rotationAngle: Double.pi/2)
            break
        case .right, .rightMirrored:
            transform = CGAffineTransform.init(translationX: 0, y: image!.size.height)
            transform = CGAffineTransform.init(rotationAngle: -Double.pi/2)
        default:
            break
        }
        
        switch image!.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = CGAffineTransform.init(translationX: image!.size.width, y: 0)
            transform = CGAffineTransform.init(scaleX: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = CGAffineTransform.init(translationX: image!.size.height, y: 0)
            transform = CGAffineTransform.init(scaleX: -1, y: 1)
            break
        default:
            break
        }
        
        
        let context = CGContext.init(data: nil, width: Int(image!.size.width), height: Int(image!.size.height), bitsPerComponent: image!.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image!.cgImage!.colorSpace!, bitmapInfo: image!.cgImage!.bitmapInfo.rawValue)
        
        context?.concatenate(transform)
        
        switch image!.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(image!.cgImage!, in: CGRect.init(x: 0, y: 0, width: image!.size.height, height: image!.size.width))
            break
            
        default:
            context?.draw(image!.cgImage!, in: CGRect.init(x: 0, y: 0, width: image!.size.width, height: image!.size.height))
            break
        }
        guard let cgimg = context?.makeImage() else{
            return image
        }
        let img = UIImage.init(cgImage: cgimg)
        return img
    }
}
