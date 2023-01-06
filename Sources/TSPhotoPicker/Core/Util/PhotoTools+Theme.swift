//
//  PhotoTools+Theme.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/14.
//

import Foundation
import Handy

extension PhotoTools{
    static func getStatusBarStylePicker(_ value : Any) -> ThemeStatusBarStylePicker? {
        if let keyPath = value as? String{
            return ThemeStatusBarStylePicker.init(keyPath: keyPath)
        }else if let styles = value as? [UIStatusBarStyle]{
            return ThemeStatusBarStylePicker.init(keyPath: "") { _ in
                
                if PhotoManager.shared.appearanceIndex < styles.count{
                    return styles[PhotoManager.shared.appearanceIndex]
                }else{
                    return styles.first
                }
            }
        }
        return nil
        
       
    }
    
    
    static func getColorPicker(_ value : Any?) -> ThemeColorPicker?{
        if let keyPath = value as? String{
            if let color = try? UIColor.handy.color(rgba_throws: keyPath){
                return ThemeColorPicker.init(keyPath: "") { _ in
                    return color
                }
            }
            return ThemeColorPicker.init(keyPath: keyPath)
        }else if let colors = value as? [Any?]{
            return ThemeColorPicker.init(keyPath: "") { _ in
                var tempColor: Any?
                if PhotoManager.shared.appearanceIndex < colors.count{
                    tempColor = colors[PhotoManager.shared.appearanceIndex]
                }else if let temp = colors.first{
                    tempColor = temp
                }
                if let tempColor = tempColor as? String{
                    return UIColor.handy.color(rgba: tempColor)
                }else if let tempColor = tempColor as? UIColor{
                    return tempColor
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
    }
    
    static func getCGColorPicker(_ value : Any?) -> ThemeCGColorPicker?{
        if let keyPath = value as? String{
            if let color = try? UIColor.handy.color(rgba_throws: keyPath){
                return ThemeCGColorPicker.init(keyPath: "") { _ in
                    return color.cgColor
                }
            }
            return ThemeCGColorPicker.init(keyPath: keyPath)
        }else if let colors = value as? [Any?]{
            return ThemeCGColorPicker.init(keyPath: "") { _ in
                var tempColor: Any?
                if PhotoManager.shared.appearanceIndex < colors.count{
                    tempColor = colors[PhotoManager.shared.appearanceIndex]
                }else if let temp = colors.first{
                    tempColor = temp
                }
                if let tempColor = tempColor as? String{
                    return UIColor.handy.color(rgba: tempColor).cgColor
                }else if let tempColor = tempColor as? UIColor{
                    return tempColor.cgColor
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
    }
    
    static func getImagePicker(_ value : Any?) -> ThemeImagePicker?{
        if let keyPath = value as? String{
            return ThemeImagePicker.init(keyPath: keyPath)
        }else if let images = value as? [Any?]{
            return ThemeImagePicker.init(keyPath: "") { _ in
                var tempImage: Any?
                if PhotoManager.shared.appearanceIndex < images.count{
                    tempImage = images[PhotoManager.shared.appearanceIndex]
                }else if let temp = images.first{
                    tempImage = temp
                }
                if let tempImage = tempImage as? String{
                    return UIImage.handy.image(for: tempImage, from: (PhotoManager.shared.bundle?.bundlePath ?? "")+"/images")
                }else if let tempImage = tempImage as? UIImage{
                    return tempImage
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
        
    }
    
    
    static func getBarStylePicker(_ value : Any?) ->ThemeBarStylePicker?{
        if let keyPath = value as? String{
            return ThemeBarStylePicker.init(keyPath: keyPath)
        }else if let styles = value as? [Any?]{
            return ThemeBarStylePicker.init(keyPath: "") { _ in
                var tempStyle: Any?
                if PhotoManager.shared.appearanceIndex < styles.count{
                    tempStyle = styles[PhotoManager.shared.appearanceIndex]
                }else if let temp = styles.first{
                    tempStyle = temp
                }
                if let tempStyle = tempStyle as? String{
                    return getStyle(stringStyle: tempStyle)
                }else if let tempStyle = tempStyle as? UIBarStyle{
                    return tempStyle
                }else{
                    return nil
                }
            }
        }else{
            return nil
        }
    }
    
    static func getStyle(stringStyle: String) -> UIBarStyle {
        switch stringStyle.lowercased() {
        case "default"  : return .default
        case "black"    : return .black
        default: return .default
        }
    }
}
