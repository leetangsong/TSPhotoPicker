//
//  PhotoPickerViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/14.
//

import UIKit

public class PhotoPickerViewController: BaseViewController {

    let config: PhotoListConfiguration
    
    init(config: PhotoListConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
