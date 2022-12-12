//
//  PhotoTools+File.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/9.
//

import Foundation
import Handy

public extension PhotoTools {
    
    /// 获取文件大小
    /// - Parameter path: 文件路径
    /// - Returns: 文件大小
    static func fileSize(atPath path: String) -> Int {
        return FileManager.handy.fileSize(atPath: path)
    }
    
    /// 获取文件夹里的所有文件大小
    /// - Parameter path: 文件夹路径
    /// - Returns: 文件夹大小
    static func folderSize(atPath path: String) -> Int {
        return FileManager.handy.folderSize(atPath: path)
    }
    /// 获取图片缓存文件夹路径
    static func getImageCacheFolderPath() -> String {
        var cachePath = FileManager.handy.cachesPath
        cachePath.append(contentsOf: "/com.lee.TSPhotoPicker/imageCache")
        FileManager.handy.folderExists(atPath: cachePath)
        return cachePath
    }
    
    /// 获取视频缓存文件夹路径
    static func getVideoCacheFolderPath() -> String {
        var cachePath = FileManager.handy.cachesPath
        cachePath.append(contentsOf: "/com.lee.TSPhotoPicker/videoCache")
        FileManager.handy.folderExists(atPath: cachePath)
        return cachePath
    }
    
    static func getAudioTmpFolderPath() -> String {
        var tmpPath = NSTemporaryDirectory()
        tmpPath.append(contentsOf: "com.lee.TSPhotoPicker/audioCache")
        FileManager.handy.folderExists(atPath: tmpPath)
        return tmpPath
    }
    
    static func getLivePhotoImageCacheFolderPath() -> String {
        var cachePath = getImageCacheFolderPath()
        cachePath.append(contentsOf: "/LivePhoto")
        FileManager.handy.folderExists(atPath: cachePath)
        return cachePath
    }
    
    static func getLivePhotoVideoCacheFolderPath() -> String {
        var cachePath = getVideoCacheFolderPath()
        cachePath.append(contentsOf: "/LivePhoto")
        FileManager.handy.folderExists(atPath: cachePath)
        return cachePath
    }
    
    /// 删除缓存
    static func removeCache() {
        removeVideoCache()
        removeImageCache()
        removeAudioCache()
    }
    
    /// 删除视频缓存
    @discardableResult
    static func removeVideoCache() -> Bool {
        return FileManager.handy.removeFile(filePath: getVideoCacheFolderPath())
    }
    
    /// 删除图片缓存
    @discardableResult
    static func removeImageCache() -> Bool {
        return FileManager.handy.removeFile(filePath: getImageCacheFolderPath())
    }
    
    /// 删除音频临时缓存
    @discardableResult
    static func removeAudioCache() -> Bool {
        return FileManager.handy.removeFile(filePath: getAudioTmpFolderPath())
    }
    
    /// 获取视频缓存文件大小
    @discardableResult
    static func getVideoCacheFileSize() -> Int {
        return FileManager.handy.folderSize(atPath: getVideoCacheFolderPath())
    }
    
    /// 获取视频缓存文件地址
    /// - Parameter key: 生成文件的key
    @discardableResult
    static func getVideoCacheURL(for key: String) -> URL {
        var cachePath = getVideoCacheFolderPath()
        cachePath.append(contentsOf: "/" + key.handy.md5 + ".mp4")
        return URL.init(fileURLWithPath: cachePath)
    }
    
    @discardableResult
    static func getAudioTmpURL(for key: String) -> URL {
        var cachePath = getAudioTmpFolderPath()
        cachePath.append(contentsOf: "/" + key.handy.md5 + ".mp3")
        return URL.init(fileURLWithPath: cachePath)
    }
    
    /// 视频是否有缓存
    /// - Parameter key: 对应视频的key
    @discardableResult
    static func isCached(forVideo key: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = getVideoCacheURL(for: key).path
        return fileManager.fileExists(atPath: filePath)
    }
    
    @discardableResult
    static func isCached(forAudio key: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = getAudioTmpURL(for: key).path
        return fileManager.fileExists(atPath: filePath)
    }
    
    /// 获取对应后缀的临时路径
    @discardableResult
    static func getTmpURL(for suffix: String) -> URL {
        var tmpPath = FileManager.handy.tempPath
        tmpPath.append(contentsOf: String.fileName(suffix: suffix))
        let tmpURL = URL.init(fileURLWithPath: tmpPath)
        return tmpURL
    }
    /// 获取图片临时路径
    @discardableResult
    static func getImageTmpURL(_ imageContentType: ImageContentType = .jpg) -> URL {
        var suffix: String
        switch imageContentType {
        case .jpg:
            suffix = "jpeg"
        case .png:
            suffix = "png"
        case .gif:
            suffix = "gif"
        default:
            suffix = "jpeg"
        }
        return getTmpURL(for: suffix)
    }
    /// 获取视频临时路径
    @discardableResult
    static func getVideoTmpURL() -> URL {
        return getTmpURL(for: "mp4")
    }
    /// 将UIImage转换成Data
    @discardableResult
    static func getImageData(for image: UIImage?) -> Data? {
        if let pngData = image?.pngData() {
            return pngData
        }else if let jpegData = image?.jpegData(compressionQuality: 1) {
            return jpegData
        }
        return nil
    }
    
    @discardableResult
    static func write(
        toFile fileURL: URL? = nil,
        image: UIImage?) -> URL? {
        if let imageData = getImageData(for: image) {
            return write(toFile: fileURL, imageData: imageData)
        }
        return nil
    }
    
    @discardableResult
    static func write(
        toFile fileURL: URL? = nil,
        imageData: Data) -> URL? {
        let imageURL = fileURL == nil ? getImageTmpURL(imageData.isGif ? .gif : .png) : fileURL!
        do {
            if FileManager.default.fileExists(atPath: imageURL.path) {
                try FileManager.default.removeItem(at: imageURL)
            }
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            return nil
        }
    }
    
}
