//
//  TSPhotoPickerConfig.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit

class TSPhotoPickerConfig: NSObject {
    static var shared = TSPhotoPickerConfig()
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    ///是否允许选择照片 默认true
    var allowSelectImage: Bool = true
    ///是否允许选择视频 默认true
    var allowSelectVideo: Bool = true
}
