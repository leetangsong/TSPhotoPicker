//
//  PhotoTools+Alert.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/9.
//

import Foundation

extension PhotoTools {
    /// 跳转系统设置界面
    static func openSettingsURL() {
        if let openURL = URL(string: UIApplication.openSettingsURLString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(openURL)
            }
        }
    }
    
    
    /// 显示UIAlertController
    public static func showAlert(
        viewController: UIViewController?,
        title: String?,
        message: String? = nil,
        leftActionTitle: String?,
        leftHandler: ((UIAlertAction) -> Void)?,
        rightActionTitle: String?,
        rightHandler: ((UIAlertAction) -> Void)?
    ) {
        guard let viewController = viewController else { return }
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if let leftActionTitle = leftActionTitle {
            let leftAction = UIAlertAction(
                title: leftActionTitle,
                style: UIAlertAction.Style.cancel,
                handler: leftHandler
            )
            alertController.addAction(leftAction)
        }
        if let rightActionTitle = rightActionTitle {
            let rightAction = UIAlertAction(
                title: rightActionTitle,
                style: UIAlertAction.Style.default,
                handler: rightHandler
            )
            alertController.addAction(rightAction)
        }
        if UIDevice.isPad {
            let pop = alertController.popoverPresentationController
            pop?.permittedArrowDirections = .any
            pop?.sourceView = viewController.view
            pop?.sourceRect = CGRect(
                x: viewController.view.frame.size.width * 0.5,
                y: viewController.view.frame.size.height,
                width: 0,
                height: 0
            )
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

