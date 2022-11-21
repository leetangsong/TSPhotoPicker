//
//  TSPhotoPickerTool.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/17.
//

import Foundation

class TSPhotoPickerTool{
    
    static func roundX(x: CGFloat) -> CGFloat{
        return round(x*100000)/100000
    }
    static func roundHundreds(x: CGFloat) -> CGFloat{
        return round(x*100)/100
    }
    
    static func rectEqual(rect1: CGRect, rect2: CGRect) -> Bool{
        return roundFrameHundreds(rect: rect1).equalTo(roundFrameHundreds(rect: rect2))
    }
    static func roundFrameHundreds(rect: CGRect) -> CGRect{
        return CGRect.init(x: roundHundreds(x: rect.origin.x), y: roundHundreds(x: rect.origin.y), width: roundHundreds(x: rect.size.width), height: roundHundreds(x: rect.size.height))
    }
    
    
   
    static func  getImage(with name:String)->UIImage?{
        var image: UIImage?
        if name.count == 0 {
            return nil
        }
        if let path = Bundle.init(for: TSPhotoPickerController.self).path(forResource: "TSPhotoPicker", ofType: "bundle") {
            image = UIImage.handy.image(with: name, from: path+"/TSPhotoPicker.bundle")
            if image == nil{
                image = UIImage.init(contentsOfFile: path+"/TSPhotoPicker.bundle/\(name).png")
            }
        }
        
        if image == nil {
            image = UIImage.init(named: name)
        }
        return image
    }
    static func getBtnStatusChangedAnimation()->CAKeyframeAnimation{
        let animate = CAKeyframeAnimation.init(keyPath: "transform")
        animate.duration = 0.4
        animate.isRemovedOnCompletion = true
        animate.fillMode = CAMediaTimingFillMode.forwards
        animate.values = [NSValue.init(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
                          NSValue.init(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
                          NSValue.init(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1.0)),
                          NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
        return animate
    }
    static func isICloudSync(error: NSError?) -> Bool{
        if error == nil {
            return false
        }
        if error!.domain == "CKErrorDomain" || error!.domain == "CloudPhotoLibraryErrorDomain"  {
            return true
        }
        return false
    }
}


