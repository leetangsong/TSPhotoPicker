//
//  Bundle+Core.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/1.
//

import Foundation

extension Bundle {
    
    static func localizedString(for key: String) -> String {
        return localizedString(for: key, value: nil)
    }
    
    static func localizedString(for key: String, value: String?) -> String {
        let bundle = PhotoManager.shared.languageBundle
        var newValue = bundle?.localizedString(forKey: key, value: value, table: nil)
        if newValue == nil {
            newValue = key
        }
        return newValue!
    }
}
