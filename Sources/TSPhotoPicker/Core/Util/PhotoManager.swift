//
//  PhotoManager.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit
import Photos
import PhotosUI
import Handy
public final class PhotoManager: NSObject {
    public static let shared = PhotoManager()
    ///主题颜色
    public var themeColor: Any = [UIColor.white]
    /// 自定义语言
    public var customLanguages: [CustomLanguage] = []
    
    /// 当配置的 languageType 都不匹配时才会判断自定义语言
    /// 固定的自定义语言，不会受系统语言影响
    public var fixedCustomLanguage: CustomLanguage?
    /// 外观样式index 每次创建PhotoPickerController时赋值   默认有2种样式   值为0为light  1为dark模式
    public var appearanceIndex: Int = 0
    ///主题改变后外观首先调用   若不使用的 keypath 模式 在这里面   修改 appearanceIndex 的值
    public var themeChangeHandle: (()->Void)?
    
    /// 当前语言文件，每次创建PhotoPickerController判断是否需要重新创建
    var languageBundle: Bundle?
    /// 当前语言类型，每次创建PhotoPickerController时赋值
    var languageType: LanguageType?
    /// 自带的bundle文件
    var bundle: Bundle?
    /// 是否使用了自定义的语言
    var isCustomLanguage: Bool = false
    
    /// 加载指示器类型
    var indicatorType: BaseConfiguration.IndicatorType = .circle
    
    var thumbnailLoadMode: ThumbnailLoadMode = .complete
    
    
    var pickerHelper: ThemePickerHelper?
    
    public override init() {
        super.init()
        if #available(iOS 13, *){
            themeChangeHandle = { [weak self] in
                if ThemeManager.systemThemeStyle == .dark{
                    self?.appearanceIndex = 1
                }else{
                    self?.appearanceIndex = 0
                }
            }
        }
        pickerHelper = ThemePickerHelper.init { [weak self] in
            self?.themeChangeHandle?()
        }
        ThemeManager.themePickers.insert(pickerHelper!, at: 0)
    }
    
    deinit {
        if let pickerHelper = pickerHelper{
            ThemeManager.themePickers.handy.remove(pickerHelper)
        }
    }
}

extension PhotoManager: HandyCompatible{}
extension NSNotification.Name {
    static let ThumbnailLoadModeDidChange: NSNotification.Name = .init("ThumbnailLoadModeDidChange")
}
extension PhotoManager {
    enum ThumbnailLoadMode {
        case simplify
        case complete
    }
    func thumbnailLoadModeDidChange(
        _ mode: ThumbnailLoadMode
    ) {
        if thumbnailLoadMode == mode {
            return
        }
        
        thumbnailLoadMode = mode
//        if !needReload && !forceReload {
//            return
//        }
//        NotificationCenter.default.post(
//            name: .ThumbnailLoadModeDidChange,
//            object: nil,
//            userInfo: ["needReload": forceReload ? true : needReload]
//        )
    }
}
