//
//  PhotoAsset.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/15.
//

import Foundation
import Photos

open class PhotoAsset: Equatable {
    /// 系统相册里的资源
    public var phAsset: PHAsset?
    /// 媒体类型
    public var mediaType: MediaType = .photo
    /// 媒体子类型
    public var mediaSubType: MediaSubType = .image
    
    /// 原图
    /// 如果为网络图片时，获取的是缩略地址的图片，也可能为nil
    /// 如果为网络视频，则为nil
    public var originalImage: UIImage?
    /// 图片/视频文件大小
//    public var fileSize: Int{ getFileSize() }
    
    /// 当前资源是否被选中
    public var isSelected: Bool = false
    
    /// 选中时的下标
    public var selectIndex: Int = 0
    
    /// 是否是 gif
    public var isGifAsset: Bool { mediaSubType.isGif }
    
    /// 是否是本地 Asset
    public var isLocalAsset: Bool { mediaSubType.isLocal }
    
    /// 是否是网络 Asset
    public var isNetworkAsset: Bool { mediaSubType.isNetwork }
    
    public static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.isEqual(rhs)
    }
}
