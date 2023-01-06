//
//  PhotoPickerController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/13.
//

import UIKit
import Handy
import Photos
open class PhotoPickerController: BaseNavigationViewController<PickerConfiguration> {
    public weak var pickerDelegate: PhotoPickerControllerDelegate?
   
    public typealias FinishHandler = (PickerResult, PhotoPickerController) -> Void
    public typealias CancelHandler = (PhotoPickerController) -> Void
    
    public var finishHandler: FinishHandler?
    public var cancelHandler: CancelHandler?
    
    /// 当前被选择的资源对应的 PhotoAsset 对象数组
    /// 外部预览时的资源数据
    public var selectedAssetArray: [PhotoAsset] = [] {
        didSet { setupSelectedArray() }
    }
    
    /// 是否选中了原图
    public var isOriginal: Bool = false
    
    /// fetch Assets 时的选项配置
    public lazy var options: PHFetchOptions = .init()
    
    /// 完成/取消时自动 dismiss ,为false需要自己在代理回调里手动 dismiss
    public var autoDismiss: Bool = true
    
    /// 本地资源数组
    /// 创建本地资源的PhotoAsset然后赋值即可添加到照片列表，如需选中也要添加到selectedAssetArray中
    public var localAssetArray: [PhotoAsset] = []
    
    // 相机拍摄存在本地的资源数组（通过相机拍摄的但是没有保存到系统相册）
    /// 可以通过 pickerControllerDidDismiss 得到上一次相机拍摄的资源，然后赋值即可显示上一次相机拍摄的资源
    public var localCameraAssetArray: [PhotoAsset] = []
    
    
    /// 刷新数据
    /// 可以在传入 selectedAssetArray 之后重新加载数据将重新设置的被选择的 PhotoAsset 选中
    /// - Parameter assetCollection: 切换显示其他资源集合
    public func reloadData(assetCollection: PhotoAssetCollection?) {
//        pickerViewController?.changedAssetCollection(collection: assetCollection)
        reloadAlbumData()
    }
    /// 刷新相册数据，只对单独控制器展示的有效
    public func reloadAlbumData() {
//        albumViewController?.tableView.reloadData()
    }
    
    /// 相册列表控制器
    public var albumViewController: AlbumViewController? {
        getViewController(
            for: AlbumViewController.self
        ) as? AlbumViewController
    }
    /// 照片选择控制器
    public var pickerViewController: PhotoPickerViewController? {
        getViewController(
            for: PhotoPickerViewController.self
        ) as? PhotoPickerViewController
    }
    /// 照片预览控制器
    public var previewViewController: PhotoPreviewViewController? {
        getViewController(
            for: PhotoPreviewViewController.self
        ) as? PhotoPreviewViewController
    }
    lazy var deniedView: DeniedAuthorizationView = {
        let deniedView = DeniedAuthorizationView.init(config: config.notAuthorized)
        deniedView.frame = view.bounds
        return deniedView
    }()
    
    
    /// 当前处于的外部预览
    public let isPreviewAsset: Bool
    let isExternalPickerPreview: Bool
    
    public override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            if (isPreviewAsset || isExternalPickerPreview) && modalPresentationStyle == .custom {
//                transitioningDelegate = self
                modalPresentationCapturesStatusBarAppearance = true
            }
        }
    }
    /// 选择资源初始化
    /// - Parameter config: 相关配置
    public convenience init(
        picker config: PickerConfiguration,
        delegate: PhotoPickerControllerDelegate? = nil
    ) {
        self.init(
            config: config,
            delegate: delegate
        )
    }
    /// 选择资源初始化
    /// - Parameter config: 相关配置
    public init(
        config: PickerConfiguration,
        delegate: PhotoPickerControllerDelegate? = nil
    ) {
        PhotoManager.shared.isFlowSystemTheme = config.isFlowSystemTheme
        PhotoManager.shared.createLanguageBundle(languageType: config.languageType)
        isPreviewAsset = false
        isExternalPickerPreview = false
        super.init(config: config)
//        if config.selectMode == .multiple &&
//            !config.allowSelectedTogether &&
//            config.maximumSelectedVideoCount == 1 &&
//            config.selectOptions.isPhoto && config.selectOptions.isVideo &&
//            config.photoList.cell.singleVideoHideSelect {
//            singleVideo = true
//        }
        modalPresentationStyle = config.modalPresentationStyle
        pickerDelegate = delegate
        var photoVC: UIViewController
        if config.albumShowMode == .normal {
            photoVC = AlbumViewController(config: config.albumList)
        }else {
            photoVC = PhotoPickerViewController(config: config.photoList)
        }
        self.viewControllers = [photoVC]
    }
    
    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if modalPresentationStyle != .custom {
            view.theme.backgroundColor = PhotoTools.getColorPicker(config.navigationViewBackgroundColor)
        }
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let status = AssetManager.authorizationStatus()
        if status.rawValue >= 1 && status.rawValue < 3 {
            deniedView.frame = view.bounds
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private function
extension PhotoPickerController {
    
    private func requestAuthorization(){
        if !config.allowLoadPhotoLibrary {
//            fetchCameraAssetCollection()
            return
        }
        let status = AssetManager.authorizationStatus()
        if status.rawValue >= 3 {
            // 有权限
//            fetchData(status: status)
        }else if status.rawValue >= 1 {
            // 无权限
            view.addSubview(deniedView)
        }else {
            // 用户还没做出选择，请求权限
//            isFirstAuthorization = true
//            AssetManager.requestAuthorization { (status) in
//                self.fetchData(status: status)
//                self.albumViewController?.updatePrompt()
//                self.pickerViewController?.reloadAlbumData()
//                self.pickerViewController?.updateBottomPromptView()
//                PhotoManager.shared.registerPhotoChangeObserver()
//            }
        }
    }
    
    private func setupSelectedArray(){
        
    }
    
    private func getViewController(for viewControllerClass: UIViewController.Type) -> UIViewController? {
        for vc in viewControllers where vc.isMember(of: viewControllerClass) {
            return vc
        }
        return nil
    }
}
