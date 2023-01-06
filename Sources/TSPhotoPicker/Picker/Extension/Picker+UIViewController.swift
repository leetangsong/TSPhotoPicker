//
//  Picker+UIViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/5.
//

import Foundation
import UIKit

extension UIViewController {
    var pickerController: PhotoPickerController? {
        if self.navigationController is PhotoPickerController {
            return self.navigationController as? PhotoPickerController
        }
        return nil
    }
}
