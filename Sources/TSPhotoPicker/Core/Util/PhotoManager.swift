//
//  PhotoManager.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/23.
//

import UIKit
import Photos
import PhotosUI
public final class PhotoManager: NSObject {
    public static let shared = PhotoManager()
    
    
    var thumbnailLoadMode: ThumbnailLoadMode = .complete
}


extension NSNotification.Name {
    static let ThumbnailLoadModeDidChange: NSNotification.Name = .init("ThumbnailLoadModeDidChange")
}
extension PhotoManager {
    enum ThumbnailLoadMode {
        case simplify
        case complete
    }
    func thumbnailLoadModeDidChange(
        _ mode: ThumbnailLoadMode
    ) {
        if thumbnailLoadMode == mode {
            return
        }
        thumbnailLoadMode = mode
//        if !needReload && !forceReload {
//            return
//        }
//        NotificationCenter.default.post(
//            name: .ThumbnailLoadModeDidChange,
//            object: nil,
//            userInfo: ["needReload": forceReload ? true : needReload]
//        )
    }
}
