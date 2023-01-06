//
//  PhotoAssetCollection.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/15.
//

import UIKit
import Photos

open class PhotoAssetCollection: Equatable {
    /// 相册名称
    public var albumName: String?
    
    /// 相册里的资源数量
    public var count: Int = 0
    
    /// PHAsset 集合
    public var result: PHFetchResult<PHAsset>?
    
    /// 相册对象
    public var collection: PHAssetCollection?
    
    /// 获取 PHFetchResult 中的 PHAsset 时的选项
    public var options: PHFetchOptions?
    
    /// 是否选中
    public var isSelected: Bool = false
    
    /// 是否是相机胶卷
    public var isCameraRoll: Bool = false
    
    /// 真实的封面图片，如果不为nil就是封面
    var realCoverImage: UIImage?
    
    private var coverImage: UIImage?
    
    public init(
        collection: PHAssetCollection?,
        options: PHFetchOptions?
    ) {
        self.collection = collection
        self.options = options
    }
    
    public init(
        albumName: String?,
        coverImage: UIImage?
    ) {
        self.albumName = albumName
        self.coverImage = coverImage
    }
    
    public static func == (lhs: PhotoAssetCollection, rhs: PhotoAssetCollection) -> Bool {
        return lhs === rhs
    }
    
    
    /// 请求获取相册封面图片
    /// - Parameter completion: 会回调多次
    /// - Returns: 请求ID
    open func requestCoverImage(
        completion: ((UIImage?, PhotoAssetCollection, [AnyHashable: Any]?) -> Void)?
    ) -> PHImageRequestID? {
        if realCoverImage != nil {
            completion?(realCoverImage, self, nil)
            return nil
        }
        if let result = result, result.count>0{
            let asset = result.object(at: result.count - 1)
            return AssetManager.requestThumbnailImage(
                for: asset,
                targetWidth: 160
            ) { (image, info) in
                completion?(image, self, info)
            }
        }
        completion?(coverImage, self, nil)
        return nil
    }
}
