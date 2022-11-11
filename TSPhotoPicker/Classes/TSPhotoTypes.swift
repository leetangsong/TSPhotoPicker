//
//  TSPhotoTypes.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/17.
//

import UIKit

@objc enum TSPhotoModelMediaType: Int{
    case unknown = 0
    case photo
    case livePhoto
    case gif
    case video
    case audio
}
@objc enum TSPhotoModelMediaSubType: Int{
    case local
    case network
}
