//
//  AlbumViewController.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/14.
//

import UIKit
import Handy
public class AlbumViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    

    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(
            frame: .zero,
            style: .plain
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(
            AlbumViewCell.self,
            forCellReuseIdentifier: "cellId"
        )
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    let config: AlbumListConfiguration
    var assetCollectionsArray: [PhotoAssetCollection] = []
    public init(config: AlbumListConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let picker = pickerController else { return }
        view.theme.backgroundColor = PhotoTools.getColorPicker(config.backgroundColor)
        
        
    }
    
    
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        assetCollectionsArray.count
    }
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellId"
        ) as! AlbumViewCell
        let assetCollection = assetCollectionsArray[indexPath.row]
        cell.assetCollection = assetCollection
        cell.config = config
        return cell
    }
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        config.cellHeight
    }

}
