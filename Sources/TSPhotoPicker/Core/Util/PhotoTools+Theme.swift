//
//  PhotoTools+Theme.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/14.
//

import Foundation
import Handy

extension PhotoTools{
    static func getStatusBarStylePicker(_ value : Any) throws -> ThemeStatusBarStylePicker {
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
        }else{
            throw ThemeError.unableParamFormat
        }
        
       
    }
    
    
    static func getColorPicker(_ value : Any) throws -> ThemeColorPicker {
        if let keyPath = value as? String{
            return ThemeColorPicker.init(keyPath: keyPath)
        }else if let colors = value as? [UIColor]{
            return ThemeColorPicker.init(keyPath: "") { _ in
                
                if PhotoManager.shared.appearanceIndex < colors.count{
                    return colors[PhotoManager.shared.appearanceIndex]
                }else{
                    return colors.first
                }
            }
        }else if let colors = value as? [String]{
            return ThemeColorPicker.init(keyPath: "") { _ in
                if PhotoManager.shared.appearanceIndex < colors.count{
                    return UIColor.handy.color(rgba: colors[PhotoManager.shared.appearanceIndex])
                }else if let color = colors.first{
                    return UIColor.handy.color(rgba: color)
                }
                return nil
            }
        }else{
            throw ThemeError.unableParamFormat
        }
    }
}
