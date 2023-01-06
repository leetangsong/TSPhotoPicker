//
//  PickerResult.swift
//  TSPhotoPicker_Example
//
//  Created by leetangsong on 2023/1/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import AVFoundation

public struct PickerResult {
    
    /// 已选的资源
    /// getURLs 获取原始资源的URL
    public let photoAssets: [PhotoAsset]
    
    /// 是否选择的原图
    public let isOriginal: Bool
    
//    /// isOriginal = false，原图未选中获取 URL 时的压缩参数
//    public var compression: PhotoAsset.Compression? = .init(
//        imageCompressionQuality: 6,
//        videoExportParameter: .init(
//            preset: .ratio_960x540,
//            quality: 6
//        )
//    )
    
    /// 初始化
    /// - Parameters:
    ///   - photoAssets: 对应 PhotoAsset 数据的数组
    ///   - isOriginal: 是否原图
    public init(
        photoAssets: [PhotoAsset],
        isOriginal: Bool
    ) {
        self.photoAssets = photoAssets
        self.isOriginal = isOriginal
    }
}
