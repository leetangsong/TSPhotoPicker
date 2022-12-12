//
//  UIDevice+Core.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/9.
//

import Foundation
import Handy
extension UIDevice{
    class var isPortrait: Bool {
        if isPad {
            return true
        }
        if  statusBarOrientation == .landscapeLeft ||
                statusBarOrientation == .landscapeRight {
            return false
        }
        return true
    }
    class var statusBarOrientation: UIInterfaceOrientation {
        UIApplication.shared.statusBarOrientation
    }
    
    class var navigationBarHeight: CGFloat {
        if isPad {
            if #available(iOS 12, *) {
                return statusBarHeight + 50
            }
        }
        return HandyApp.naviBarHeight
    }
    class var generalStatusBarHeight: CGFloat {
        HandyApp.isIphoneX ? 44 : 20
    }
    
    class var statusBarHeight: CGFloat {
        let statusBarHeight: CGFloat
        let window = UIApplication.shared.windows.first
        if #available(iOS 13.0, *),
           let height = window?.windowScene?.statusBarManager?.statusBarFrame.size.height {
            statusBarHeight = height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        }
        return statusBarHeight
    }
    
    class var isPad: Bool {
        current.userInterfaceIdiom == .pad
    }
}
