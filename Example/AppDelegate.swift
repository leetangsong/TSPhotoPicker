//
//  AppDelegate.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/6.
//

import UIKit
import Handy
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.runOnce()
        if #available(iOS 13.0, *) {
            ThemeManager.followSystemThemeAction = { type in
                ThemeManager.changeTheme()
            }
            ThemeManager.isFollowSystemTheme = true
        }
        return true
    }

   


}

