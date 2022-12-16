//
//  ThemeDeallocBlockExecutor.swift
//  Handy
//
//  Created by leetangsong on 2022/11/2.
//

import Foundation


public class ThemeDeallocBlockExecutor{
    public var pickerHelper: ThemePickerHelper?
    public init(pickerHelper: ThemePickerHelper?) {
        self.pickerHelper = pickerHelper
    }
    deinit {
        if let pciker = pickerHelper {
            ThemeManager.themePickers.handy.remove(pciker)
        }
    }
}
