//
//  TSPhotoPickerController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Handy
import CoreLocation


public protocol TSPhotoPickerControllerDelegate: AnyObject{
    
}

public class TSPhotoPickerController: UINavigationController {
    private(set) var maxImagesCount: Int = 0
    var minImagesCount: Int = 0
    var albumCellDidSetModelBlock: ((_ cell: TSAlbumCell)->Void)?
    var albumCellDidLayoutSubviewsBlock: ((_ cell: TSAlbumCell)->Void)?
    
    public var naviBgColor: ThemeColorPicker = ["34,34,34"]{
        didSet{
            TSPhotoPickerConfig.shared.naviBgColor = naviBgColor
        }
    }
    
    public weak var pickerDelegate: TSPhotoPickerControllerDelegate?{
        didSet{
//            TSPhotoManager.shared.pickerDelegate = pickerDelegate
        }
    }
    
    lazy var selectedModels: [TSPhotoModel] = []
    
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    var currentAlbum: TSAlbumModel?{
        didSet{
            if oldValue == currentAlbum  {
                return
            }
            oldValue?.isSelected = false
            if oldValue == nil {
                for album in self.albumsListVC.albums {
                    album.isSelected = false
                }
            }
            currentAlbum?.isSelected = true
            for vc in self.viewControllers {
                if let imageSelectVC = vc as? TSPhotoSelectViewController{
                    imageSelectVC.albumModel = currentAlbum
                    break
                }
            }
        }
    }
    private(set) lazy var albumsListVC = TSAlbumListViewController()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.theme.textColor = TSPhotoPickerConfig.shared.tipTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "请在iPhone的\"设置-隐私-照片\"选项中，允许\(HandyApp.appName)访问你的手机相册"
        return label
    }()
    
    private lazy var settingBtn: UIButton = {
        let button = UIButton()
        button.setTitle(TSPhotoPickerConfig.shared.settingBtnTitleStr, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(settingBtnClick), for: .touchUpInside)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.settingBtnTitleColor, forState: .normal)
       
        return button
    }()
    
    
     public init(maxImagesCount: Int, columnNumber: Int = 4, delegate: TSPhotoPickerControllerDelegate? = nil) {
        self.maxImagesCount = maxImagesCount
        TSPhotoManager.shared.columnNumber = columnNumber
        self.pickerDelegate = delegate
        let selectedPhoto = TSPhotoSelectViewController()
        selectedPhoto.columnNumber = TSPhotoManager.shared.columnNumber
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        pushViewController(selectedPhoto, animated: false)
        if !TSPhotoManager.shared.authorizationStatusAuthorized(complete: {
            self.authrizationStatusChange()
        }) {
            selectedPhoto.view.addSubview(tipLabel)
            selectedPhoto.view.addSubview(settingBtn)

        }else{
            getAllAlbums()
            TSPhotoManager.shared.getCameraRollAlbum(needFetchAssets: false) { model in
                selectedPhoto.albumModel = model
            }
        }
        
        
    }
     public override func viewDidLoad() {
        super.viewDidLoad()
        handy.navigationStyle = .custom
        
    }
   
    func getAllAlbums(){
        DispatchQueue.global().async {
            TSPhotoManager.shared.getAllAlbums(needFetchAssets: false) { albums in
                DispatchQueue.main.async {
                    if self.albumsListVC.albums.count == 0 {
                        for album in albums {
                            if album.isCameraRoll {
                                album.isSelected = true
                                break
                            }
                        }
                    }
                    self.albumsListVC.albums = albums
                }
            }
        }
        
    }
    @objc func authrizationStatusChange(){
        
        tipLabel.removeFromSuperview()
        settingBtn.removeFromSuperview()
        TSPhotoManager.shared.getCameraRollAlbum(needFetchAssets: false) { model in
            if let vc = self.viewControllers.first as? TSPhotoSelectViewController{
                vc.albumModel = model
            }
        }
        getAllAlbums()
//        timer?.invalidate()
//        timer = nil
//        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
//            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(observeAuthrizationStatusChange), userInfo: nil, repeats: false)
//        }
//        if TSImageManager.shared.authorizationStatusAuthorized() {
//            tipLabel.removeFromSuperview()
//            settingBtn.removeFromSuperview()
//            TSImageManager.shared.getCameraRollAlbum(needFetchAssets: false) { model in
//                if let vc = self.viewControllers.first as? TSImageSelectViewController{
//                    vc.albumModel = model
//                }
//            }
//            getAllAlbums()
//        }
        
    }
    @objc func settingBtnClick(){
        if let url = URL.init(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url)
        }
    }
    @discardableResult
    func showAlert(with title: String) -> UIAlertController{
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        present(alertController, animated: true)
        return alertController
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tipLabel.frame = CGRect.init(x: 8, y: 120, width: view.frame.width-16, height: 60)
        settingBtn.frame = CGRect.init(x: 0, y: 180, width: view.frame.width, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class TSLocationManager: NSObject, CLLocationManagerDelegate{
    static let manager = TSLocationManager()
    
    private lazy var locationManager = CLLocationManager()
    private  var successHandler: ((_ locations: [CLLocation])->Void)? = nil
    private var failHandler: ((_ error: Error?)->Void)? = nil
    private var geocoderHandler: ((_ geocoderArray: [CLPlacemark])->Void)? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func startLocation(success: ((_ locations: [CLLocation])->Void)? = nil, fail: ((_ error: Error?)->Void)? = nil, geocoderHandler: ((_ geocoderArray: [CLPlacemark])->Void)? = nil){
        locationManager.startUpdatingLocation()
        self.successHandler = success
        self.failHandler = fail
        self.geocoderHandler = geocoderHandler
    }
    
    /// 结束定位
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    //地理位置发生改变时触发
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        successHandler?(locations)
        if locations.count > 0 {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(locations.first!) { array, error in
                self.geocoderHandler?(array ?? [])
            }
        }
    }
    /// 定位失败回调方法
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failHandler?(error)
    }
}
