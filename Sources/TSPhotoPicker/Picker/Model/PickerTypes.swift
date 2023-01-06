//
//  PickerTypes.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/15.
//

import Foundation
import Photos
/// 资源类型可选项
public struct PickerAssetOptions: OptionSet {
    /// Photo 静态照片
    public static let photo = PickerAssetOptions(rawValue: 1 << 0)
    /// Video 视频
    public static let video = PickerAssetOptions(rawValue: 1 << 1)
    /// Gif 动图（包括静态图）
    public static let gifPhoto = PickerAssetOptions(rawValue: 1 << 2)
    /// LivePhoto 实况照片
    public static let livePhoto = PickerAssetOptions(rawValue: 1 << 3)
    
    public var isPhoto: Bool {
        contains(.photo) || contains(.gifPhoto) || contains(.livePhoto)
    }
    public var isVideo: Bool {
        contains(.video)
    }
    
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public enum PickerSelectMode: Int {
    /// 单选模式
    case single = 0
    /// 多选模式
    case multiple = 1
}

public extension PhotoAsset {
    enum MediaType: Int {
        /// 照片
        case photo = 0
        /// 视频
        case video = 1
    }

    enum MediaSubType: Equatable {
        /// 手机相册里的图片
        case image
        /// 手机相册里的动图
        case imageAnimated
        /// 手机相册里的LivePhoto
        case livePhoto
        /// 手机相册里的视频
        case video
        /// 本地图片
        case localImage
        /// 本地视频
        case localVideo
        /// 本地LivePhoto
        case localLivePhoto
        /// 本地动图
        case localGifImage
        /// 网络图片
        case networkImage(Bool)
        /// 网络视频
        case networkVideo
        
        public var isLocal: Bool {
            switch self {
            case .localImage, .localGifImage, .localVideo, .localLivePhoto:
                return true
            default:
                return false
            }
        }
        
        public var isPhoto: Bool {
            switch self {
            case .image, .imageAnimated, .livePhoto, .localImage, .localLivePhoto, .localGifImage, .networkImage(_):
                return true
            default:
                return false
            }
        }
        
        public var isVideo: Bool {
            switch self {
            case .video, .localVideo, .networkVideo:
                return true
            default:
                return false
            }
        }
        
        public var isGif: Bool {
            switch self {
            case .imageAnimated, .localGifImage:
                return true
            case .networkImage(let isGif):
                return isGif
            default:
                return false
            }
        }
        
        public var isNetwork: Bool {
            switch self {
            case .networkImage(_), .networkVideo:
                return true
            default:
                return false
            }
        }
    }
    enum DownloadStatus: Int {
        /// 未知，不用下载或还未开始下载
        case unknow
        /// 下载成功
        case succeed
        /// 下载中
        case downloading
        /// 取消下载
        case canceled
        /// 下载失败
        case failed
    }
    
    /// 网络视频加载方式
    enum LoadNetworkVideoMode {
        /// 先下载
        case download
        /// 直接播放
        case play
    }
}
public enum AlbumShowMode: Int {
    /// 正常展示
    case normal = 0
    /// 弹出展示
    case popup = 1
}


public enum PickerPresentStyle {
    case present
    case push
}
