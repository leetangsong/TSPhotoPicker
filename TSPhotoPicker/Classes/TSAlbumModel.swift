//
//  TSAlbumModel.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/10/18.
//

import UIKit
import Photos
///相册
class TSAlbumModel: NSObject {
    var name: String?
    var count: Int = 0
    var result: PHFetchResult<PHAsset>?
    var collection: PHAssetCollection?
    var options: PHFetchOptions?
    var models: [TSPhotoModel] = []
    var selectedModels: [TSPhotoModel] = []
    var selectedCount: Int = 0
    var isCameraRoll: Bool = false
    var isSelected: Bool = false
    
    func setResult(_ result: PHFetchResult<PHAsset>, needFetchAssets: Bool){
        self.result = result
        count = result.count
        if needFetchAssets {
            TSPhotoManager.shared.getAssetModel(from: result) { models in
                self.models = models
                self.checkSelectedModels()
            }
        }
    }
    func refreshFetchResult(){
        let fetchResult = PHAsset.fetchAssets(in: collection!, options: options)
        count = fetchResult.count
        result = fetchResult
    }
    func checkSelectedModels(){
        selectedCount = 0
        var selectedAssets: [PHAsset] = []
        for model in selectedModels {
            if model.asset != nil{
                selectedAssets.append(model.asset!)
            }
            
        }
        for model in models {
            if model.asset != nil, selectedAssets.contains(model.asset!) {
                selectedCount += 1
            }
        }
    }
}
