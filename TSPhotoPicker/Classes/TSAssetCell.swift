//
//  TSAssetCell.swift
//  TSAssetCell
//
//  Created by leetangsong on 2022/4/29.
//

import UIKit
import Photos
import Handy
class TSAlbumCell: UITableViewCell {

    var albumCellDidSetModelBlock: ((_ cell: TSAlbumCell)->Void)?
    var albumCellDidLayoutSubviewsBlock: ((_ cell: TSAlbumCell)->Void)?
    private(set) lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.theme.textColor = TSPhotoPickerConfig.shared.textColor
        contentView.addSubview(label)
        return label
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.addSubview(view)
        return view
    }()
    private(set) lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = TSPhotoPickerTool.getImage(with: "icon_album_selected")
        contentView.addSubview(imageView)
        return imageView
    }()
    
    var albumModel: TSAlbumModel?{
        didSet{
           
            if albumModel == nil {
                return
            }
            
            titleLabel.theme.attributedText = ThemeAttributedStringPicker(keyPath: "", map: { [weak self] _ in
                guard let color = TSPhotoPickerConfig.shared.textColor.value() as? UIColor else{
                    return nil
                }
                let nameString = NSMutableAttributedString.init(string: self?.albumModel?.name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: color])
                let countString = NSAttributedString.init(string: "  (\(self?.albumModel?.count ?? 0))", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray])
                nameString.append(countString)
                return nameString
            })
            posterImageView.image = nil
            TSPhotoManager.shared.getPostImage(with: albumModel!) { image in
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }
            selectedImageView.isHidden = !albumModel!.isSelected
            
            
            albumCellDidSetModelBlock?(self)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor  = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedImageView.frame = CGRect.init(x: contentView.frame.size.width-20-14, y: 0, width: 14, height: 14)
        posterImageView.frame = CGRect.init(x: 0, y: 0, width: contentView.frame.size.height, height: contentView.frame.size.height)
        titleLabel.frame = CGRect.init(x: posterImageView.frame.maxY+15, y: 0, width: contentView.frame.size.width-contentView.frame.size.height-50, height: contentView.frame.size.height)
        selectedImageView.center = CGPoint.init(x: selectedImageView.center.x, y: contentView.frame.size.height/2)
        lineView.frame = CGRect.init(x: contentView.frame.size.height, y: contentView.frame.size.height-0.5, width: contentView.frame.size.width, height: 0.5)
        
        albumCellDidLayoutSubviewsBlock?(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



//class TSAssetCell: UICollectionViewCell {
//    
//    var imageRequestID: PHImageRequestID = 0
//    var bigImageRequestID: PHImageRequestID = 0
//    var identifier: String?
//    var index: Int?{
//        didSet{
//            if let _index = index {
//                self.btnSelect.setTitle("\(_index+1)", for: .selected)
//            }
//        }
//    }
////    var selectedBlock: ((_ selected: Bool)->Void)?
////    lazy var progressView: TSProgressView = {
////        let temp = TSProgressView()
//////        temp.isHidden = true
////        addSubview(temp)
////        return temp
////    }()
////    lazy var imageView: UIImageView = {
////        let temp = UIImageView()
////        temp.contentMode = .scaleAspectFill
////        temp.clipsToBounds = true
////        return temp
////    }()
////    lazy var btnSelect: UIButton  = {
////        let temp = UIButton.init(type: .custom)
////        temp.imageView?.contentMode = .left
////        let image = TSImagePickerTool.getImage(with: "icon_selected")
////        temp.setImage(image, for: .normal)
////        temp.setImage(UIImage(), for: .selected)
////        temp.setPicker_EnlargeEdge(edge: UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 20))
////        temp.addTarget(self, action: #selector(btnSelectClick(send:)), for: .touchUpInside)
////        temp.setBackgroundImage(UIImage.picker_image(color: TSImagePickerConfig.shared.themeColor), for: .selected)
////        temp.layer.cornerRadius = 23/2.0
////        temp.titleLabel?.font = UIFont.systemFont(ofSize: 14)
////        temp.setTitleColor(.white, for: .normal)
////        temp.layer.masksToBounds = true
////        return temp
////    }()
////    lazy var videoBottomView: UIImageView = {
////        let temp = UIImageView()
////        temp.image = TSImagePickerTool.getImage(with: "videoView")
////        return temp
////    }()
////    lazy var videoImageView: UIImageView = {
////        let temp = UIImageView()
////        temp.image = TSImagePickerTool.getImage(with: "video")
////        temp.frame = CGRect.init(x: 5, y: 2, width: 16, height: 12)
////        return temp
////    }()
////    lazy var liveImageView: UIImageView = {
////        let temp = UIImageView()
////        temp.contentMode = .scaleAspectFill
////        temp.image = TSImagePickerTool.getImage(with: "livePhoto")
////        temp.frame = CGRect.init(x: 5, y: 0, width: 14, height: 14)
////        return temp
////    }()
////    lazy var timeLabel: UILabel = {
////        let temp = UILabel()
////        temp.textAlignment = .right
////        temp.font = UIFont.systemFont(ofSize: 13)
////        temp.textColor = .white
////        return temp
////    }()
////    lazy var topView: UIView = {
////        let temp = UIView()
////        temp.backgroundColor = UIColor.init(white: 1, alpha: 0.6)
////        return temp
////    }()
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        initUI()
////    }
////    
////    func initUI(){
////        contentView.addSubview(imageView)
////        contentView.addSubview(topView)
////        contentView.addSubview(btnSelect)
////        contentView.addSubview(videoBottomView)
////        videoBottomView.addSubview(videoImageView)
////        videoBottomView.addSubview(liveImageView)
////        videoBottomView.addSubview(timeLabel)
////        
////    }
////    @objc func btnSelectClick(send: UIButton){
////        
////        selectedBlock?(send.isSelected)
////        if send.isSelected {
////            send.layer.add(TSImagePickerTool.getBtnStatusChangedAnimation(), forKey: nil)
////            requestBigImage()
////        }else{
////            cancelBigImageRequest()
////        }
////        
////    }
////    var model: TSPhotoModel!{
////        
////        didSet{
////            let configure = TSImagePickerConfig.shared
////            if model.type == .video{
////                videoBottomView.isHidden = false
////                videoImageView.isHidden = false
////                liveImageView.isHidden = true
////                timeLabel.text = model.timeLength
////            }else if model.type == .gif{
////                videoBottomView.isHidden = !configure.allowSelectGif
////                videoImageView.isHidden = true
////                liveImageView.isHidden = true
////                timeLabel.text = "GIF"
////
////            }else if model.type == .livePhoto{
////                videoBottomView.isHidden = !configure.allowSelectLivePhoto
////                videoImageView.isHidden = true
////                liveImageView.isHidden = false
////                timeLabel.text = "Live"
////            }else{
////                videoBottomView.isHidden = true
////            }
////
////            self.identifier = model.asset.localIdentifier
////            self.btnSelect.isSelected = model.isSelected
////            self.topView.isHidden = model.canSelected
//////            self.btnSelect.isHidden = TSPhotoConfiguration.defaultConfiguration
////            self.imageView.image = nil
////            let requestID = TSImageManager.shared.getPhoto(with: model.asset, photoWidth: frame.width, completion: { [weak self] (photo, info, isDegraded) in
////                if self?.identifier == self?.model.asset.localIdentifier{
////                    self?.imageView.image = photo
////                }else{
////                    if  let id = self?.imageRequestID {
////                        PHImageManager.default().cancelImageRequest(id)
////                    }
////                }
////                if !isDegraded{
////                    self?.hideProgressView()
////                    self?.imageRequestID = 0
////                }
////            })
////            if requestID > 0 , imageRequestID > 0, imageRequestID != requestID {
////                PHImageManager.default().cancelImageRequest(imageRequestID)
////            }
////            
////            self.imageRequestID = requestID
////            
////            // 如果用户选中了该图片，提前获取一下大图
//////            if model.isSelected {
//////                requestBigImage()
//////            }else{
//////                cancelBigImageRequest()
//////            }
////            
////        }
////    }
////    
////    func requestBigImage(){
////        if bigImageRequestID>0 {
////            PHImageManager.default().cancelImageRequest(bigImageRequestID)
////        }
////        bigImageRequestID = TSImageManager.shared.getOriginalPhotoData(with: model.asset, progressHandler: { progress, error, stop, info in
////            DispatchQueue.main.async {
////                if self.model.isSelected {
////                    self.progressView.progress = progress > 0.02 ? progress : 0.02
////                    self.progressView.isHidden = false
////                    self.imageView.alpha = 0.4
////                    if progress >= 1 {
////                        self.hideProgressView()
////                    }
////                }else{
////                    self.cancelBigImageRequest()
////                }
////            }
////            
////            
////        }, completion: { data, info, isDegraded in
////            let iCloudSyncFailed = data == nil && TSImagePickerTool.isICloudSync(error: info?[PHImageErrorKey] as? NSError)
////            self.model.iCloudFailed = iCloudSyncFailed
////            DispatchQueue.main.async {
////                if iCloudSyncFailed {
////                    self.selectedBlock?(true)
////                    self.btnSelect.isSelected = false
////                }
////                self.hideProgressView()
////            }
////            
////        })
////        
////        if model.type == .video {
////            TSImageManager.shared.getVideo(with: model.asset, completion: { item, info in
////                let iCloudSyncFailed = item == nil && TSImagePickerTool.isICloudSync(error: info?[PHImageErrorKey] as? NSError)
////                self.model.iCloudFailed = iCloudSyncFailed
////                if iCloudSyncFailed{
////                    DispatchQueue.main.async {
////                        self.selectedBlock?(true)
////                        self.btnSelect.isSelected = false
////                    }
////                }
////            })
////
////        }
////    }
////    
////    func cancelBigImageRequest(){
////        if bigImageRequestID>0 {
////            PHImageManager.default().cancelImageRequest(bigImageRequestID)
////        }
////        hideProgressView()
////    }
////    func hideProgressView(){
////        progressView.isHidden = true
////        imageView.alpha = 1.0
////    }
////    
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        let progressWH: CGFloat = 20
////        let progressXY = (frame.size.width - progressWH) / 2
////        imageView.frame = bounds
////        progressView.frame = CGRect.init(x: progressXY, y: progressXY, width: progressWH, height: progressWH)
////        btnSelect.frame = CGRect.init(x: frame.width-26, y: 5, width: 23, height: 23)
////        videoBottomView.frame = CGRect.init(x: 0, y: frame.height-16, width: frame.width, height: 16)
////        timeLabel.frame = CGRect.init(x: 30, y: 2, width: frame.width-35, height: 12)
////        topView.frame = bounds
////    }
////    
////   
////    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////    
////}
////
////
////
////class TSAssetCameraCell: UICollectionViewCell {
////    lazy var imageView: UIImageView = {
////        let temp = UIImageView()
////        temp.contentMode = .scaleAspectFill
////        temp.clipsToBounds = true
////        return temp
////    }()
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        backgroundColor = .white
////        contentView.addSubview(imageView)
////    }
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        imageView.frame = bounds
////    }
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////    
////}
////
////
////class TSAssetAddMoreCell: TSAssetCameraCell {
////    private(set) lazy var tipLabel: UILabel = {
////        let label = UILabel()
////        label.numberOfLines = 2
////        label.textAlignment = .center
////        label.font = UIFont.systemFont(ofSize: 12)
////        label.lineBreakMode = .byTruncatingMiddle
////        label.textColor = TSImagePickerTool.rgba(156, 156, 156)
////        contentView.addSubview(label)
////        return label
////    }()
////    
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        clipsToBounds = true
////    }
////    override func layoutSubviews() {
////        super.layoutSubviews()
////        tipLabel.frame = CGRect.init(x: 5, y: frame.size.height/2, width: frame.size.width-10, height: frame.size.height/2-5)
////    }
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////}
