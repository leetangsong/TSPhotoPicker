//
//  TSPhotoModel.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/13.
//

import UIKit
import Photos


class TSPhotoModel: NSObject {
    ///创建日期
    ///如果是通过相机拍摄的并且没有保存到相册(临时的) 为当前时间
    var creationDate: Date?
    ///修改日期
    ///如果是通过相机拍摄的并且没有保存到相册(临时的) 为当前时间
    var modificationDate: Date?
   
    var location: CLLocation?
    
    var type: TSPhotoModelMediaType = .photo
    
    var subType: TSPhotoModelMediaSubType = .local
    
    var asset: PHAsset?
    /// 视频秒数
    var videoDuration: TimeInterval = -1
    var timeLength: String?
    var selectedIndex: Int = -1
    ///照片原始宽高
    var imageSize: CGSize = .zero
    ///本地视频URL / 网络视频地址
    var videoURL: URL?
    ///livephoto - 网络视频地址
    var livePhotoVideoURL: URL?
    ///网络图片地址
    var networkPhotoURL: URL?
    ///网络图片缩略图地址
    var networkThumbURL: URL?
    
    // MARK: - icloud
    var isICloud: Bool = false
    ///iCloud 是否正在下载
    var iCloudDownloading: Bool = false
    ///iCloud 下载进度
    var iCloudProgress: CGFloat = 0
    
    var iCloudRequestID: PHImageRequestID = -1
    
    init(asset: PHAsset, timeLength: String? = nil) {
        self.asset = asset
        self.type = TSPhotoManager.shared.transformAssetType(asset: asset)
        self.timeLength = timeLength
    }
    
}
