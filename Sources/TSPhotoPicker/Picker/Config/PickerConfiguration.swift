//
//  PickerConfiguration.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/14.
//

import Foundation
import Handy
public class PickerConfiguration: BaseConfiguration {
    
    ///是否跟随系统主题变化 默认为true
    public var isFlowSystemTheme: Bool = true
    
    // 资源可选项，控制获取系统相册资源的类型
    /// .livePhoto .gifPhoto 是photo的子项
    /// 默认只获取静态图片和视频
    public var selectOptions: PickerAssetOptions = [.photo, .video]
    /// 选择模式
    public var selectMode: PickerSelectMode = .multiple
    /// 照片和视频可以一起选择
    public var allowSelectedTogether: Bool = true
    
    /// 允许加载系统照片库
    public var allowLoadPhotoLibrary: Bool = true
    
    /// 选择照片时，先判断是否在iCloud上。如果在iCloud上会先同步iCloud上的资源
    /// 如果在断网或者系统iCloud出错的情况下:
    /// true: 选择失败
    /// fasle: 获取原始图片会失败
    public var allowSyncICloudWhenSelectPhoto: Bool = true
    /// 相册展示模式
    public var albumShowMode: AlbumShowMode = .normal
    
    /// 获取资源列表时是否按创建时间排序
    public var isCreationDate: Bool = false
    
    /// 最多可以选择的照片数，如果为0则不限制
    public var maximumSelectedPhotoCount: Int = 0
    
    /// 最多可以选择的视频数，如果为0则不限制
    public var maximumSelectedVideoCount: Int = 0
    
    /// 最多可以选择的资源数，如果为0则不限制
    public var maximumSelectedCount: Int = 9
    
    /// 视频最大选择时长，为0则不限制
    public var maximumSelectedVideoDuration: Int = 0
    
    /// 视频最小选择时长，为0则不限制
    public var minimumSelectedVideoDuration: Int = 0
    
    /// 视频选择的最大文件大小，为0则不限制
    public var maximumSelectedVideoFileSize: Int = 0
    
    /// 照片选择的最大文件大小，为0则不限制
    public var maximumSelectedPhotoFileSize: Int = 0
    

    /// 选择器展示样式，当 albumShowMode = .popup 并且全屏弹出时有效
    public var pickerPresentStyle: PickerPresentStyle = .present
    
    
    /// 当 albumShowMode = .popup 并且全屏弹出时   是否允许右滑手势返回。与微信右滑手势返回一致
    public var allowRightSwipeGestureBack: Bool = true
    
    /// 右滑返回手势触发范围，距离屏幕左边的距离
    public var rightSwipeGestureTriggerRange: CGFloat = 50
    
    
    /// 相册列表配置
    public lazy var albumList: AlbumListConfiguration = .init()
    
    /// 照片列表配置
    public lazy var photoList: PhotoListConfiguration = .init()
    
    /// 未授权提示界面相关配置
    public lazy var notAuthorized: NotAuthorizedConfiguration = .init()
    
    /// 是否缓存[相机胶卷/所有照片]相册
    public var isCacheCameraAlbum: Bool = true
    
    public override init() {
        super.init()
//        PhotoManager.shared.isCacheCameraAlbum = isCacheCameraAlbum
    }
}
