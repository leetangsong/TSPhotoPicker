//
//  DeniedAuthorizationView.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2023/1/5.
//

import Foundation
import Handy

class DeniedAuthorizationView: UIView{
    let config: NotAuthorizedConfiguration
    
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar.init()
        navigationBar.setBackgroundImage(
            UIImage.handy.image(for: .clear),
            for: UIBarMetrics.default
        )
        navigationBar.shadowImage = UIImage.init()
        let navigationItem = UINavigationItem.init()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: closeBtn)
        navigationBar.pushItem(navigationItem, animated: false)
        return navigationBar
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton.init(type: .custom)
        closeBtn.handy.size = CGSize(width: 50, height: 40)
        closeBtn.addTarget(self, action: #selector(didCloseClick), for: .touchUpInside)
        closeBtn.contentHorizontalAlignment = .left
        return closeBtn
    }()
    
    lazy var titleLb: UILabel = {
        let titleLb = UILabel.init()
        titleLb.textAlignment = .center
        titleLb.numberOfLines = 0
        return titleLb
    }()
    
    lazy var subTitleLb: UILabel = {
        let subTitleLb = UILabel.init()
        subTitleLb.textAlignment = .center
        subTitleLb.numberOfLines = 0
        return subTitleLb
    }()
    
    lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton.init(type: .custom)
        jumpBtn.layer.cornerRadius = 5
        jumpBtn.addTarget(self, action: #selector(jumpSetting), for: .touchUpInside)
        return jumpBtn
    }()
    
    init(config: NotAuthorizedConfiguration) {
        self.config = config
        super.init(frame: CGRect.zero)
        configView()
    }
    func configView() {
        if !config.hiddenCloseButton {
            addSubview(navigationBar)
        }
        addSubview(titleLb)
        addSubview(subTitleLb)
        addSubview(jumpBtn)
        
        titleLb.text = "无法访问相册中照片".localized
        titleLb.font = UIFont.semiboldPingFang(ofSize: 20)
        
        subTitleLb.text = "当前无照片访问权限，建议前往系统设置，\n允许访问「照片」中的「所有照片」。".localized
        subTitleLb.font = UIFont.regularPingFang(ofSize: 17)
        
        jumpBtn.setTitle("前往系统设置".localized, for: .normal)
        jumpBtn.titleLabel?.font = UIFont.mediumPingFang(ofSize: 16)
        
        configColor()
    }
    
    func configColor() {
        closeBtn.theme.setImage(PhotoTools.getImagePicker(config.closeButtonImageName), forState: .normal)
        theme.backgroundColor = PhotoTools.getColorPicker(config.backgroundColor)
       
        titleLb.theme.textColor = PhotoTools.getColorPicker(config.titleColor)
        subTitleLb.theme.textColor = PhotoTools.getColorPicker(config.subTitleColor)
        jumpBtn.theme.backgroundColor = PhotoTools.getColorPicker(config.jumpButtonBackgroundColor)
        
        jumpBtn.theme.setTitleColor(PhotoTools.getColorPicker(config.jumpButtonTitleColor), forState: .normal)
       
    }
    
    @objc func didCloseClick() {
        self.handy.viewController?.dismiss(animated: true, completion: nil)
    }
    @objc func jumpSetting() {
        PhotoTools.openSettingsURL()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var barHeight: CGFloat = 0
        var barY: CGFloat = 0
        if let pickerController = handy.viewController as? PhotoPickerController {
            barHeight = pickerController.navigationBar.handy.height
            if pickerController.modalPresentationStyle == .fullScreen {
                barY = HandyApp.statusBarHeight
            }
        }
        navigationBar.frame = CGRect(x: 0, y: barY, width: handy.width, height: barHeight)
        
        let titleHeight = titleLb.text?.handy.height(ofFont: titleLb.font, maxWidth: handy.width) ?? 0
        titleLb.frame = CGRect(x: 0, y: 0, width: handy.width, height: titleHeight)
        
        let subTitleHeight = subTitleLb.text?.handy.height(ofFont: subTitleLb.font, maxWidth: handy.width - 40) ?? 0
        let subTitleY: CGFloat
        if barHeight == 0 {
            subTitleY = handy.height / 2 - subTitleHeight
        }else {
            subTitleY = handy.height / 2 - subTitleHeight - 30 - HandyApp.safeAreaTop
        }
        subTitleLb.frame = CGRect(
            x: 20,
            y: subTitleY,
            width: handy.width - 40,
            height: subTitleHeight
        )
        titleLb.handy.top = subTitleLb.handy.top - 15 - titleHeight
        
        let jumpBtnBottomMargin: CGFloat = UIDevice.isProxy() ? 120 : 50
        var jumpBtnWidth = (jumpBtn.currentTitle?.handy.width(ofFont: jumpBtn.titleLabel!.font, maxHeight: 40) ?? 0 ) + 10
        if jumpBtnWidth < 150 {
            jumpBtnWidth = 150
        }
        let jumpY: CGFloat
        if barHeight == 0 {
            jumpY = handy.height - HandyApp.safeAreaBottom - 50
        }else {
            jumpY = handy.height - HandyApp.safeAreaBottom - 40 - jumpBtnBottomMargin
        }
        jumpBtn.frame = CGRect(
            x: 0,
            y: jumpY,
            width: jumpBtnWidth,
            height: 40
        )
        jumpBtn.handy.centerX = handy.width * 0.5
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
