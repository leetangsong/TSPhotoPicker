//
//  BaseNavigationViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/5.
//

import UIKit
import Handy
open class BaseNavigationViewController<T: BaseConfiguration>: UINavigationController {

    /// 相关配置
    public let config: T
    
    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return getStatusBarStyle()
    }
    
    open override var prefersStatusBarHidden: Bool{
        return topViewController?.handy.statusBarHidden ?? false
    }
    init(config: T) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        handy.navigationStyle = config.navigationStyle
        // Do any additional setup after loading the view.
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
