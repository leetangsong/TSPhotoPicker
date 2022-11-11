//
//  TSPhotoPickerController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Handy


protocol TSPhotoPickerControllerDelegate{
    
}

class TSPhotoPickerController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handy.navigationStyle = .custom
        
    }
    init(maxImagesCount: Int, columnNumber: Int = 4, delegate: TSPhotoPickerControllerDelegate? = nil) {
//        self.maxImagesCount = maxImagesCount
//        TSImageManager.shared.columnNumber = columnNumber
//        self.pickerDelegate = delegate
        let selectedPhoto = TSPhotoSelectViewController()
//        selectedPhoto.columnNumber = TSImageManager.shared.columnNumber
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        pushViewController(selectedPhoto, animated: false)
//        if !TSImageManager.shared.authorizationStatusAuthorized(complete: {
//            self.authrizationStatusChange()
//        }) {
//            selectedPhoto.view.addSubview(tipLabel)
//            selectedPhoto.view.addSubview(settingBtn)
//
//        }else{
//            getAllAlbums()
//            TSImageManager.shared.getCameraRollAlbum(needFetchAssets: false) { model in
//                selectedPhoto.albumModel = model
//            }
//        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
