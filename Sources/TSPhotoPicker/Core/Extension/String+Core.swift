//
//  String+Core.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/9.
//

import Foundation
import Handy
extension String{
    
    var localized: String { Bundle.localizedString(for: self) }
    
    
    static func fileName(suffix: String) -> String {
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "").lowercased()
        var fileName = uuid
        let nowDate = Date().timeIntervalSince1970
        
        fileName.append(String(format: "%d", arguments: [nowDate]))
        fileName.append(String(format: "%d", arguments: [arc4random()%10000]))
        return suffix.isEmpty ? fileName.handy.md5 : fileName.handy.md5 + "." + suffix
    }
    
}
