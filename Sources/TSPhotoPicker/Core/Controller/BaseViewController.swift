//
//  BaseViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/16.
//

import UIKit
import Handy
open class BaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        if #available(iOS 13.0, *) {
            return
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationDidChanged(notify:)),
            name: UIApplication.didChangeStatusBarOrientationNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationWillChanged(notify:)),
            name: UIApplication.willChangeStatusBarOrientationNotification,
            object: nil
        )
    }
    ///设置导航栏
    open func setupNavigation(){
        if let navi = navigationController as? BaseNavigationViewController{
            let config = navi.config
            theme.naviTitleColor = PhotoTools.getColorPicker(config.navigationTitleColor)
            theme.naviTintColor = PhotoTools.getColorPicker(config.navigationTintColor)
            theme.naviBarStyle = PhotoTools.getBarStylePicker(config.navigationBarStyle)
            theme.statusBarStyle =  PhotoTools.getStatusBarStylePicker(config.statusBarStyle)
            theme.naviBackgroundColor = PhotoTools.getColorPicker(config.navigationBarBackgroundColor)
            handy.naviIsTranslucent = config.navigationBarIsTranslucent
        }
        
    }
    
    @objc open func deviceOrientationDidChanged(notify: Notification) {
        
    }
    
    @objc open func deviceOrientationWillChanged(notify: Notification) {
        
    }
    
    open override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        guard #available(iOS 13.0, *) else {
            return
        }
        deviceOrientationWillChanged(notify: .init(name: UIApplication.willChangeStatusBarOrientationNotification))
        coordinator.animate(alongsideTransition: nil) { _ in
            self.deviceOrientationDidChanged(
                notify: .init(
                    name: UIApplication.didChangeStatusBarOrientationNotification
                )
            )
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        PhotoTools.removeCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
