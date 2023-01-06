//
//  BaseConfiguration.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/13.
//

import Foundation
import Handy
open class BaseConfiguration {
    
    public var modalPresentationStyle: UIModalPresentationStyle
    
    ///导航栏样式
    public var navigationStyle: HandyNavigationStyle = .system
    
    /// 如果自带的语言不够，可以添加自定义的语言文字
    /// PhotoManager.shared.customLanguages 自定义语言数组
    /// PhotoManager.shared.fixedCustomLanguage 如果有多种自定义语言，可以固定显示某一种
    /// 语言类型
    public var languageType: LanguageType = .system
    
    var statusBarStyle: Any = [UIStatusBarStyle.default, UIStatusBarStyle.lightContent]
    /// 半透明效果
    public var navigationBarIsTranslucent: Bool = true
    
    /// 导航控制器背景颜色
    public var navigationViewBackgroundColor: Any = [UIColor.white, "#2E2F30"]
    
    /// 导航栏样式
    public var navigationBarStyle: Any = [UIBarStyle.default, UIBarStyle.black]
    /// 导航栏背景颜色
    public var navigationBarBackgroundColor: Any?
    
    /// 导航栏标题颜色
    public var navigationTitleColor: Any = [UIColor.black, UIColor.white]
    
    public var navigationTintColor: Any?
    
    /// 隐藏状态栏
    public var prefersStatusBarHidden: Bool = false
    
    /// 允许旋转，全屏情况下才可以禁止旋转
    public var shouldAutorotate: Bool = true
    
    /// 支持的方向
    public var supportedInterfaceOrientations: UIInterfaceOrientationMask = .all
    
    /// 加载指示器类型
    public var indicatorType: IndicatorType = .circle {
        didSet { PhotoManager.shared.indicatorType = indicatorType }
    }
    
    public init() {
        if #available(iOS 13.0, *) {
            modalPresentationStyle = .automatic
        } else {
            modalPresentationStyle = .fullScreen
        }
        PhotoManager.shared.indicatorType = indicatorType
    }
}

public extension BaseConfiguration {
    /// 加载指示器类型
    enum IndicatorType {
        /// 渐变圆环
        case circle
        /// 系统菊花
        case system
    }
}
