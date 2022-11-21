//
//  TSPhotoPickerConfig.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Handy
class TSPhotoPickerConfig: NSObject {
    static var shared = TSPhotoPickerConfig()
    
    var languageBundle: Bundle?
    
    var statusBarStyle: ThemeStatusBarStylePicker = [.lightContent]
    
    
    ///同时选择图片和视频的时候  是否生成新的视频  默认不生成
    var isMixVideo: Bool = false
    //默认为true，如果设置为NO, 用户将不能拍摄照片
    var allowTakePicture: Bool  = true
    //默认为true，如果设置为NO, 用户将不能拍摄视频
    var allowTakeVideo: Bool = true
    ///是否允许选择照片 默认true
    var allowSelectImage: Bool = true
    
    ///是否允许选择视频 默认true
    var allowSelectVideo: Bool = true
    ///是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为false，则不显示gif标识 默认true
    var allowSelectGif: Bool = true
    //FIXME: ios9 以上系统支持
    ///是否允许选择Live Photo，只是控制是否选择，并不控制是否显示，如果为false，则不显示Live Photo标识 默认false, ios9 以上系统支持
    var allowSelectLivePhoto: Bool = true
    
    ///是否允许Force Touch功能 默认true
    var allowForceTouch: Bool = true
    
    ///是否允许编辑图片，默认true
    var allowEditImage: Bool = true
    
    ///是否允许编辑视频，选择一张时候才允许编辑，默认false
    var allowEditVideo: Bool = false
    
    ///是否允许选择原图，默认true
    var allowSelectOriginal: Bool = true
    
    ///背景是否跟随系统变化
    var appearanceFollowSystem: Bool = true
    ///允许拍照时候定位
    var allowCameraLocation: Bool = true
    
    var notScaleImage: Bool = true
    
    ///是否保存到app命名的相册
    var isSaveToAPPAlbum: Bool = true
    
    
    ///编辑视频时最大裁剪时间，单位：秒，默认10s 且最低10s;当该参数为10s时，所选视频时长必须大于等于10s才允许进行编辑
    var maxEditVideoTime: Int = 10
    
    /// 允许选择视频的最大时长，单位：秒， 默认 120s
    var maxVideoDuration: TimeInterval = 60*10
    
    
    // 默认是false，如果设置为true，导出视频时会修正转向（慎重设为YES，可能导致部分安卓下拍的视频导出失败）
    var needFixComposition: Bool = false
    
    
    var naviBgColor: ThemeColorPicker = ["34,34,34"]
    var naviTintColor: ThemeColorPicker = ["#FFF"]
    var titleColor: ThemeColorPicker = ["#FFF"]
    var subTitleColor: ThemeColorPicker = ["#FFF"]
    var tipTextColor: ThemeColorPicker = ["#FFF"]
    ///cell按钮选中的颜色
    var themeColor: ThemeColorPicker = ["46,168,237"]
    var buttonDisableColor: ThemeColorPicker = ["44,44,44"]
//
    var textColor: ThemeColorPicker = ["#FFF"]
    var disableTextColor: ThemeColorPicker = ["255,255,255,0.5"]
    
    var defaultBackgroundColor: ThemeColorPicker = ["44,43,41"]
    var settingBtnTitleStr: String = "设置"
    var settingBtnTitleColor: ThemeColorPicker = ["46,168,237"]
    
    var isMixVideoTip: String = "同时选择图片和视频，需制作成新的视频再发表"
    var mixVideoDoneTitle: String = "下一步"
    var doneTitle: String = "完成"
    
    var bottomBarMiddleNormalImage: ThemeImagePicker?
    var bottomBarMiddleSelectedImage: ThemeImagePicker?
}

