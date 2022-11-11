//
//  TSAssetManager.swift
//  Pods
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Photos
class TSAssetManager: NSObject {

    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    var sortAscending: Bool = true
    
    ///获取所有相册
    func getAllAlbums(needFetchAssets: Bool, completion:((_ albums: [TSAlbumModel])->Void)? = nil){
        let config = TSPhotoPickerConfig.shared
        let option = PHFetchOptions()
        if  !config.allowSelectVideo {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
        }
        if  !config.allowSelectImage {
            option.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.video.rawValue)
        }
        if config.allowSelectVideo && config.allowSelectImage  {
            option.predicate = nil
        }
        
        if !sortAscending{
            option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: sortAscending)]
        }
        
        ///获取智能相册
//        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.any, options: nil)
//        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.any, options: nil)
        let myPhotoStreamAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumMyPhotoStream, options: nil)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumSyncedAlbum, options: nil)
        let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumCloudShared, options: nil)
        let arrAlbums: [PHFetchResult<PHAssetCollection>] = [myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums]
        var albums: [TSAlbumModel] = []
        
        for result in arrAlbums{
            result.enumerateObjects({ (collection, index, stop) in
                if !collection.isKind(of: PHAssetCollection.self){
                    return
                }
                //过滤空相册
                if collection.estimatedAssetCount <= 0, collection.assetCollectionSubtype != .smartAlbumUserLibrary {
                    return
                }
                let fetchResult = PHAsset.fetchAssets(in: collection, options: option)
                if fetchResult.count < 1, collection.assetCollectionSubtype != .smartAlbumUserLibrary {
                    return
                }
//                if collection.assetCollectionSubtype.rawValue == 215 { return }
//                if collection.assetCollectionSubtype.rawValue == 212 { return }
//                if collection.assetCollectionSubtype.rawValue == 204 { return }
                if collection.assetCollectionSubtype.rawValue == 1000000201 { return }
                if collection.assetCollectionSubtype == .smartAlbumAllHidden { return }
                //获取相册内asset result
                if collection.assetCollectionSubtype == .smartAlbumUserLibrary{
                    let model = self.getAlbumModel(with: fetchResult, collection: collection, isCameraRoll: true, needFetchAssets: needFetchAssets, options: option)
                    albums.insert(model, at: 0)
                }else{
                    let model = self.getAlbumModel(with: fetchResult, collection: collection, isCameraRoll: false, needFetchAssets: needFetchAssets, options: option)
                    albums.append(model)
                }
            })
        }
        completion?(albums)
        
    }
    
    
    ///相册模型
    private func getAlbumModel(with result: PHFetchResult<PHAsset>, collection: PHAssetCollection, isCameraRoll: Bool, needFetchAssets: Bool, options: PHFetchOptions) -> TSAlbumModel{
        let model = TSAlbumModel()
        model.isCameraRoll = isCameraRoll
        model.collection = collection
        model.setResult(result, needFetchAssets: needFetchAssets)
        model.name = collection.localizedTitle
        model.options = options
        model.count = result.count
        return model
    }
    
}
