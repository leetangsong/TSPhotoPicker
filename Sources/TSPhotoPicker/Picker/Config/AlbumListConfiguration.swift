//
//  AlbumListConfiguration.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/3.
//

import UIKit

// MARK: 相册列表配置类
public struct AlbumListConfiguration {
    /// 可访问权限下的提示语颜色
    public var limitedStatusPromptColor: Any = ["#999999"]
    
    /// 当相册里没有资源时的相册名称
    public var emptyAlbumName: String = "所有照片"
    
    /// 当相册里没有资源时的封面图片名
    public var emptyCoverImageName: String = "picker_album_empty"
    
    /// 列表背景颜色 [正常，暗黑] （默认[UIColor.white, UIColor.handy.color(rgba: "#2E2F30")]）
    public var backgroundColor: Any = [UIColor.white, "#2E2F30"]
    
    /// 自定义cell，继承 AlbumViewCell 加以修改
    public var customCellClass: AlbumViewCell.Type?
    
    /// cell高度
    public var cellHeight: CGFloat = 100
    
    /// cell背景颜色 [正常，暗黑]  （默认  [UIColor.white, UIColor.handy.color(rgba: "#2E2F30")]）
    public var cellBackgroundColor: Any = [UIColor.white, "#2E2F30"]
    
    
    
    /// cell选中时的颜色 [正常，暗黑] （默认  [nil , UIColor.handy.color(rgba: "32,32,32")]）
    public var cellSelectedColor: Any = [nil, "32,32,32"]
    
   
    /// 相册名称颜色 [正常，暗黑]
    public var albumNameColor: Any = [UIColor.black, UIColor.white]
    
    /// 相册名称字体
    public var albumNameFont: UIFont = .mediumPingFang(ofSize: 15)
    
    /// 照片数量颜色 [正常，暗黑] （默认  ["#999999", "#dadada"]）
    public var photoCountColor: Any = ["#999999", "#dadada"]
    
    /// 是否显示照片数量
    public var showPhotoCount: Bool = true
    
    /// 照片数量字体
    public var photoCountFont: UIFont = .mediumPingFang(ofSize: 12)
    
    /// 分隔线颜色 [正常，暗黑]  （默认 ["#eeeeee", "#434344"]）
    public var separatorLineColor: Any = ["#eeeeee", "#434344"]
    
    /// 选中勾勾的颜色
    public var tickColor: Any = [PhotoManager.shared.systemTintColor,"#ffffff" ]
    
    public init() { }
}
