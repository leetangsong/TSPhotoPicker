//
//  ViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 10/13/2022.
//  Copyright (c) 2022 leetangsong. All rights reserved.
//

import UIKit
#if canImport(GDPerformanceView_Swift)
import GDPerformanceView_Swift
#endif

import TSPhotoPicker
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func photopicker(_ sender: Any) {
//        let picker = TSPhotoPickerController.init(maxImagesCount: 4)
//        present(picker, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if canImport(GDPerformanceView_Swift)
        PerformanceMonitor.shared().start()
        #endif
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

