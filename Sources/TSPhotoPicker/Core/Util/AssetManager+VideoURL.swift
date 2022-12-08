//
//  AssetManager+VideoURL.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/8.
//

import Foundation
import Photos

public extension AssetManager {
    
    typealias VideoURLResultHandler = (Result<URL, AssetError>) -> Void
    
    
    
    /// 获取原始视频
    /// - Parameters:
    ///   - asset: 对应的 PHAsset 数据
    ///   - fileURL: 指定视频地址
    ///   - isOriginal: 是否获取系统相册最原始的数据，如果在系统相册编辑过，则获取的是未编辑的视频
    ///   - resultHandler: 获取结果
    static func requestOriginalVideoURL(
        for asset: PHAsset,
        toFile fileURL: URL,
        isOriginal: Bool = false,
        resultHandler: @escaping VideoURLResultHandler
    ) {
        var videoResource: PHAssetResource?
        var resources: [PHAssetResourceType: PHAssetResource] = [:]
        for resource in PHAssetResource.assetResources(for: asset) {
            resources[resource.type] = resource
        }
        if isOriginal {
            if let resource = resources[.video] {
                videoResource = resource
            }else if let resource = resources[.fullSizeVideo] {
                videoResource = resource
            }
        }else {
            if let resource = resources[.fullSizeVideo] {
                videoResource = resource
            }else if let resource = resources[.video] {
                videoResource = resource
            }
        }
        
        guard let videoResource = videoResource else {
            resultHandler(.failure(.assetResourceIsEmpty))
            return
        }
        if !PhotoTools.removeFile(fileURL: fileURL) {
            resultHandler(.failure(.removeFileFailed))
            return
        }
        
    }
    
    
}
