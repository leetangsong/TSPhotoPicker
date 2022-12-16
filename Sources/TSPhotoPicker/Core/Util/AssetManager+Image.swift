//
//  AssetManager+Image.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/16.
//

import Foundation
import Photos
public typealias ImageResultHandler = (UIImage?, [AnyHashable: Any]?) -> Void

extension AssetManager{
    
    
    /// 请求获取缩略图
    /// - Parameters:
    ///   - asset: 资源对象
    ///   - targetWidth: 获取的图片大小
    ///   - completion: 完成
    /// - Returns: 请求ID
    @discardableResult
    static func requestThumbnailImage(
        for asset: PHAsset,
        targetWidth: CGFloat,
        completion: ImageResultHandler?
    ) -> PHImageRequestID {
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        var isSimplify = PhotoManager.shared.thumbnailLoadMode == .simplify
        return requestImage(
            for: asset,
            targetSize: isSimplify ? .init(
                width: targetWidth,
                height: targetWidth
            ) : PhotoTools.transformTargetWidthToSize(
                targetWidth: targetWidth,
                asset: asset
            ),
            options: options
        ) { (image, info) in
            DispatchQueue.main.async {
                completion?(image, info)
            }
        }
    }
    
    
    /// 请求image
    /// - Parameters:
    ///   - asset: 资源对象
    ///   - targetSize: 指定大小
    ///   - options: 可选项
    ///   - resultHandler: 回调
    /// - Returns: 请求ID
    @discardableResult
    static func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        options: PHImageRequestOptions,
        resultHandler: @escaping ImageResultHandler
    ) -> PHImageRequestID {
        return PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options,
            resultHandler: resultHandler
        )
    }
}
