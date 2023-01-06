//
//  AlbumViewCell.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/3.
//

import UIKit
import Photos
import Handy

open class AlbumViewCell: UITableViewCell {

    /// 封面图片
    public lazy var albumCoverView: UIImageView = {
        let albumCoverView = UIImageView.init()
        albumCoverView.contentMode = .scaleAspectFill
        albumCoverView.clipsToBounds = true
        return albumCoverView
    }()
    
    /// 相册名称
    public lazy var albumNameLb: UILabel = {
        let albumNameLb = UILabel.init()
        return albumNameLb
    }()
    
    /// 底部线
    public lazy var bottomLineView: UIView = {
        let bottomLineView = UIView.init()
        bottomLineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        return bottomLineView
    }()
    
    /// 相册里的照片数量
    public lazy var photoCountLb: UILabel = {
        let photoCountLb = UILabel.init()
        return photoCountLb
    }()
    
    /// 选中时的勾勾
    public lazy var tickView: AlbumTickView = {
        let tickView = AlbumTickView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return tickView
    }()
    
    /// 选中时的背景视图
    public lazy var selectedBgView: UIView = {
        let selectedBgView = UIView.init()
        return selectedBgView
    }()
    /// 配置
    public var config: AlbumListConfiguration? {
        didSet {
            guard let config = config else {
                return
            }
            albumNameLb.font = config.albumNameFont
            photoCountLb.font = config.photoCountFont
            photoCountLb.isHidden = !config.showPhotoCount
            configColor()
        }
    }
    
    /// 照片集合
    public var assetCollection: PhotoAssetCollection? {
        didSet {
            guard let assetCollection = assetCollection else {
                return
            }
            albumNameLb.text = assetCollection.albumName
            photoCountLb.text = String(assetCollection.count)
            tickView.isHidden = !assetCollection.isSelected
            requestCoverImage()
        }
    }
    
    /// 请求id
    public var requestID: PHImageRequestID?
    
    open func initView() {
        contentView.addSubview(albumCoverView)
        contentView.addSubview(albumNameLb)
        contentView.addSubview(photoCountLb)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(tickView)
    }
    
    func requestCoverImage(){
        cancelRequest()
        requestID = assetCollection?.requestCoverImage(completion: {[weak self] (image, assetCollection, info) in
            guard let self = self else { return }
            if let info = info, info.isCancel { return }
            if let image = image, assetCollection == self.assetCollection {
                self.albumCoverView.image = image
                if !AssetManager.assetIsDegraded(for: info) {
                    self.requestID = nil
                }
            }
        })
    }
    
    func configColor(){
        albumNameLb.theme.textColor = PhotoTools.getColorPicker(config?.albumNameColor)
        photoCountLb.theme.textColor = PhotoTools.getColorPicker(config?.photoCountColor)
        bottomLineView.theme.backgroundColor = PhotoTools.getColorPicker(config?.separatorLineColor)
        tickView.tickLayer.theme.strokeColor = PhotoTools.getCGColorPicker(config?.tickColor)
        theme.backgroundColor = PhotoTools.getColorPicker(config?.cellBackgroundColor)
        
        
        if let picker = PhotoTools.getColorPicker(config?.cellSelectedColor){
            selectedBgView.theme.backgroundColor = picker
            selectedBackgroundView = selectedBgView
        }else{
            selectedBackgroundView = nil
        }
    }

    open func layoutView(){
        let coverMargin: CGFloat = 5
        let coverWidth = handy.height - (coverMargin * 2)
        albumCoverView.frame = CGRect(x: coverMargin, y: coverMargin, width: coverWidth, height: coverWidth)
        
        tickView.handy.left = handy.width - 12 - tickView.handy.width - HandyApp.safeAreaInsets.right
        tickView.handy.centerY = handy.height * 0.5
        
        albumNameLb.handy.left = albumCoverView.frame.maxX + 10
        albumNameLb.handy.size = CGSize(width: tickView.handy.left - albumNameLb.handy.left - 20, height: 16)
        
        if let showPhotoCount = config?.showPhotoCount, showPhotoCount {
            albumNameLb.handy.centerY = handy.height / 2 - albumNameLb.handy.height / 2
            
            photoCountLb.handy.left = albumCoverView.frame.maxX + 10
            photoCountLb.handy.top = albumNameLb.frame.maxY + 5
            photoCountLb.handy.size = CGSize(width: handy.width - photoCountLb.handy.left - 20, height: 14)
        }else {
            albumNameLb.handy.centerY = handy.height / 2
        }
        
        bottomLineView.frame = CGRect(x: coverMargin, y: handy.height - 0.5, width: handy.width - coverMargin * 2, height: 0.5)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutView()
    }
    
    public func cancelRequest() {
        guard let requestID = requestID else { return }
        PHImageManager.default().cancelImageRequest(requestID)
        self.requestID = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        cancelRequest()
    }
}
