//
//  ImageContentType.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/9.
//

import Foundation

public enum ImageContentType: String {
    case jpg, png, gif, unknown
    public var fileExtension: String {
        return self.rawValue
    }
}
