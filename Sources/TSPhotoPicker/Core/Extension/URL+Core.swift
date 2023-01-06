//
//  URL+Core.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/29.
//

import Foundation

extension URL {
    var isGif: Bool {
        absoluteString.hasSuffix("gif") || absoluteString.hasSuffix("GIF")
    }
    var fileSize: Int {
        guard let fileSize = try? resourceValues(forKeys: [.fileSizeKey]) else {
            return 0
        }
        return fileSize.fileSize ?? 0
    }
}
