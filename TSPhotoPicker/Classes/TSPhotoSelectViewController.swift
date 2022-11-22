//
//  TSPhotoSelectViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/19.
//

import UIKit
import Handy
import Photos
import CoreServices
private let kReuseIdentifier = "photoCell"
class TSPhotoSelectViewController: UIViewController {
    var columnNumber: Int = 4
    var authorizationLimited: Bool = false
    var showTakePhotoBtn: Bool = true
    var isSelectOriginalPhoto: Bool = false
    
    lazy var bottomBar: TSPhotoBottomBar = {
        let bar = TSPhotoBottomBar()
        bar.leftTitle = "预览"
        bar.middleTitle = "原图"
        if !TSPhotoPickerConfig.shared.allowSelectOriginal{
            bar.middleButton.isHidden = true
        }
        bar.isHidden = true
        bar.leftButton.isEnabled = false
        bar.doneButton.isEnabled = false
        bar.middleButtonAction = { [weak self] selected in
            self?.isSelectOriginalPhoto = selected
            self?.refreshBottomToolBarStatus()
        }
        bar.leftButtonAction = { [weak self] in
            let navi = self?.navigationController as? TSPhotoPickerController
            self?.jumpToPreviewController(source: navi?.selectedModels ?? [], currentIndex: 0)
            
        }
        bar.doneButtonAction = { [weak self] in
            self?.doneButtonClick()
        }
        return bar
    }()
    var albumModel: TSAlbumModel?{
        didSet{
            if oldValue == nil && albumModel != nil {
//                PHPhotoLibrary.shared().register(self)
            }
//            shouldScrollToBottom = true
            bottomBar.isHidden = false
            let confi = TSPhotoPickerConfig.shared
            showTakePhotoBtn = albumModel?.isCameraRoll == true && (confi.allowTakePicture && confi.allowSelectImage || confi.allowTakeVideo && confi.allowSelectVideo)
//
            authorizationLimited = albumModel?.isCameraRoll == true && TSPhotoManager.shared.isPHAuthorizationStatusLimited()
//
            DispatchQueue.main.async {
                self.titleLabel.text = self.albumModel?.name
                self.updateTitleButtonFrame()
//                self.fetchAssetModels()
            }
            
        }
    }
    
    
    private lazy var albumsListBgView: UIView = {
        let view = UIView.init(frame: view.bounds)
        view.handy.top = HandyApp.naviBarHeight
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.handy.color(rgba: "77,75,76")
        button.layer.cornerRadius = 34/2
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = TSPhotoPickerTool.getImage(with: "icon_arrow")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return theme.statusBarStyle?.value() as? UIStatusBarStyle ?? .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let navi = navigationController as? TSPhotoPickerController
        handy.naviShadowHidden = true
        view.theme.backgroundColor = TSPhotoPickerConfig.shared.defaultBackgroundColor
        theme.naviBackgroundColor = TSPhotoPickerConfig.shared.naviBgColor
        theme.naviTitleColor = TSPhotoPickerConfig.shared.titleColor
        theme.naviTintColor = TSPhotoPickerConfig.shared.naviTintColor
        theme.statusBarStyle = TSPhotoPickerConfig.shared.statusBarStyle
        let closeItem = UIBarButtonItem.init(image: TSPhotoPickerTool.getImage(with: "icon_close"), style: .done, target: self, action: #selector(closePicker))
        handy.navigationItem.leftBarButtonItem = closeItem
        view.addSubview(bottomBar)
        bottomBar.doneTitle = TSPhotoPickerConfig.shared.doneTitle
        bottomBar.theme.barTintColor = navi?.naviBgColor
        setupAlbumsListView()
    }
  
   
    @objc func closePicker(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func selectAlbum(_ button: UIButton){
        button.isSelected = !button.isSelected
        button.isSelected ? showAlbumsListView() : hiddenAlbumsListView()
    }
    
    //MARK: - titleButton 相关配置
    private func setupAlbumsListView(){
        titleButton.addSubview(titleLabel)
        titleButton.addSubview(arrowImageView)
        titleButton.addTarget(self, action: #selector(selectAlbum(_:)), for: .touchUpInside)
        let navi = navigationController as? TSPhotoPickerController
        let albumsListView = navi!.albumsListVC.view
        addChild(navi!.albumsListVC)
        view.addSubview(albumsListBgView)
        albumsListBgView.isHidden = true
        albumsListBgView.addSubview(albumsListView!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenAlbumsListView))
        tap.delegate = self
        albumsListBgView.addGestureRecognizer(tap)
        
    }
    func showAlbumsListView(){
        self.titleButton.isEnabled = false
        let navi = navigationController as? TSPhotoPickerController
        let albumsListView = navi!.albumsListVC.view
        albumsListBgView.isHidden = false
        
        var height: CGFloat = CGFloat(navi!.albumsListVC.albums.count * 55)
        if height > (HandyApp.screenHeight - HandyApp.naviBarHeight - 150){
            height = HandyApp.screenHeight - HandyApp.naviBarHeight - 150
        }
        albumsListView?.frame = CGRect.init(x: 0, y: -height, width: self.view.frame.size.width, height:height)
        self.albumsListBgView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            albumsListView?.handy.top = 0
            self.albumsListBgView.alpha = 1
            self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: Double.pi)
        } completion: { _ in
            self.titleButton.isEnabled = true
        }
        
    }
    @objc func hiddenAlbumsListView(){
        self.titleButton.isEnabled = false
        let navi = navigationController as? TSPhotoPickerController
        let albumsListView = navi!.albumsListVC.view
        self.titleButton.isSelected = false
        UIView.animate(withDuration: 0.2) {
            albumsListView?.handy.top = -(albumsListView?.handy.height ?? 0)/3*2
            self.albumsListBgView.alpha = 0
            self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: Double.pi*2)
        } completion: { _ in
            self.albumsListBgView.isHidden = true
            self.titleButton.isEnabled = true
        }
        
    }
    
    func updateTitleButtonFrame(){
        if authorizationLimited {
            title = albumModel?.name
            return
        }
        let width = NSAttributedString.init(string: titleLabel.text ?? "", attributes: [.font: titleLabel.font!]).size().width
        let totalWidth = 10+width+2+24+6+5
        let titleView = UIView()
        self.titleButton.center = CGPoint.init(x: totalWidth/2, y: 34/2)
        titleView.addSubview(titleButton)
        UIView.animate(withDuration: handy.navigationItem.titleView == nil ? 0 : 0.25) {
            self.titleLabel.frame = CGRect.init(x: 10, y: 0, width: width+2, height: 34)
            self.arrowImageView.frame = CGRect.init(x: self.titleLabel.frame.maxX+6, y: 5, width: 24, height: 24)
            self.titleButton.frame = CGRect.init(x: 0, y: 0, width: totalWidth, height: 34)
            titleView.frame = self.titleButton.bounds
            self.titleButton.center = CGPoint.init(x: totalWidth/2, y: 34/2)
        }
        handy.navigationItem.titleView = titleView
    }
    
    //MARK: -  底部bar相关配置
    func jumpToPreviewController(source: [TSPhotoModel?] ,currentIndex: Int){
//        let imagePreview = TSPhotoPreviewController()
//
//
//        let sourceData = source.filter { $0 != nil}
//
//        imagePreview.sourceDatas = sourceData as! [TSPhotoModel]
//        imagePreview.isSelectOriginalPhoto = isSelectOriginalPhoto
//        imagePreview.doneButtonClickBlock = { [weak self] isSelectOriginalPhoto in
//            self?.isSelectOriginalPhoto = isSelectOriginalPhoto
//            self?.doneButtonClick()
//        }
//        imagePreview.backButtonClickBlock = { [weak self] isSelectOriginalPhoto in
//            self?.isSelectOriginalPhoto = isSelectOriginalPhoto
//            self?.checkSelectedModels()
//            self?.collectionView.reloadData()
//            self?.refreshBottomToolBarStatus()
//            self?.updateTipBarStatus()
//        }
//        imagePreview.currentIndex = currentIndex - getRealBeginIndex()
//        navigationController?.pushViewController(imagePreview, animated: true)
    }
    
    func refreshBottomToolBarStatus(){
        let navi = navigationController as! TSPhotoPickerController
        bottomBar.middleButton.isSelected = isSelectOriginalPhoto
        bottomBar.leftButton.isEnabled = navi.selectedModels.count != 0
        bottomBar.doneButton.isEnabled = navi.selectedModels.count != 0
        
        let selected = bottomBar.middleButton.isSelected
        bottomBar.setMiddleButtonAppearance()
        if !selected || (selected && navi.selectedModels.count == 0){
            bottomBar.middleSubTitle = ""
        }else{
            TSPhotoManager.shared.getPhotosBytes(with: navi.selectedModels) { totalBytes in
                DispatchQueue.main.async {
                    self.bottomBar.middleSubTitle = "共\(totalBytes)"
                }
            }
        }
        
       
        if navi.selectedModels.count == 0 {
           bottomBar.doneTitle = TSPhotoPickerConfig.shared.doneTitle
        }else{
            bottomBar.doneTitle = "\(shouldMixVideo() ? TSPhotoPickerConfig.shared.mixVideoDoneTitle : TSPhotoPickerConfig.shared.doneTitle) (\(navi.selectedModels.count))"
        }
    }
    
    func doneButtonClick(){
        
    }
    
    //判断是否需要混合图片视频
    func shouldMixVideo() -> Bool{
        let pickerVC = navigationController as! TSPhotoPickerController
        var haveVideo = false
        var haveImage = false
        for selectedModel in pickerVC.selectedModels {
            if selectedModel.type == .video && TSPhotoPickerConfig.shared.isMixVideo {
                haveVideo = true
            }
            if selectedModel.type != .video {
                haveImage = true
            }
        }
        return haveVideo && haveImage
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = (view.frame.size.width-4*CGFloat(columnNumber+1))/CGFloat(columnNumber)
        let bottomHeight = HandyApp.safeAreaInsets.bottom + 50
       
        albumsListBgView.frame = CGRect.init(x: 0, y: HandyApp.naviBarHeight, width: HandyApp.screenWidth, height: HandyApp.screenHeight-HandyApp.naviBarHeight)
        bottomBar.frame = CGRect.init(x: 0, y: view.frame.size.height-bottomHeight, width: view.frame.size.width, height: bottomHeight)
    }

}
extension TSPhotoSelectViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != albumsListBgView {
            return false
        }
        return true
    }
}
