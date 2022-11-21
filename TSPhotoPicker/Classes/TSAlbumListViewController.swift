//
//  TSAlbumListViewController.swift
//  TSImagePickerController
//
//  Created by leetangsong on 2022/5/6.
//

import UIKit
import Handy
class TSAlbumListViewController: UIViewController {

    var albums: [TSAlbumModel] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.masksToBounds = true
        tableView.theme.backgroundColor = TSPhotoPickerConfig.shared.defaultBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TSAlbumCell.self, forCellReuseIdentifier: "TSAlbumCell")
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        view.handy.cornerRadius(viewSize: view.frame.size,corners: [.bottomLeft, .bottomRight], radii: 8)
    }
    
    deinit {
        print("销毁 \(type(of: self))")
    }
    
}

extension TSAlbumListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let navi = navigationController as? TSPhotoPickerController
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSAlbumCell") as? TSAlbumCell
        
        cell?.albumCellDidSetModelBlock = navi?.albumCellDidSetModelBlock
        cell?.albumCellDidLayoutSubviewsBlock = navi?.albumCellDidLayoutSubviewsBlock
        cell?.albumModel = albums[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumModel = albums[indexPath.row]
        let navi = navigationController as? TSPhotoPickerController
        navi?.currentAlbum = albumModel
        tableView.reloadData()
        let vc = self.parent as? TSPhotoSelectViewController
        vc?.hiddenAlbumsListView()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}


