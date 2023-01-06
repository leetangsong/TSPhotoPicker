//
//  NotAuthorizedConfiguration.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/5.
//

import Foundation

// MARK: 未授权界面配置类
public struct NotAuthorizedConfiguration {
    
    /// 背景颜色
    public var backgroundColor: Any = [UIColor.white, "#2E2F30"]
    
    /// 关闭按钮图片名
    public var closeButtonImageName: Any = ["ts_picker_notAuthorized_close", "ts_picker_notAuthorized_close_dark"]

    /// 隐藏关闭按钮
    public var hiddenCloseButton: Bool = false
    
    /// 标题颜色
    public var titleColor: Any = [UIColor.black, UIColor.white]
    
    /// 子标题颜色
    public var subTitleColor: Any = ["#444444", UIColor.white]
    
    /// 跳转按钮背景颜色
    public var jumpButtonBackgroundColor: Any = ["#333333", UIColor.white]
    
    /// 跳转按钮文字颜色
    public var jumpButtonTitleColor: Any = ["#ffffff", "#333333"]
    
    public init() { }
}
