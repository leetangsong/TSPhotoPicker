//
//  TSPhotoBottomBar.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/11/21.
//

import UIKit
import Handy
class TSPhotoBottomBar: UIToolbar {

    var doneTitle: String?{
        didSet{
            doneButton.setTitle(doneTitle, for: .normal)
            setNeedsLayout()
        }
    }
    var leftTitle: String?{
        didSet{
            leftButton.setTitle(leftTitle, for: .normal)
        }
    }
    
    var middleTitle: String?{
        didSet{
            middleButton.setTitle(" \(middleTitle ?? "")", for: .normal)
        }
    }
    
    var middleSubTitle: String?{
        didSet{
            middleSubLabel.text = middleSubTitle
        }
    }
    
    
    var leftButtonAction: (()->Void)?
    var doneButtonAction: (()->Void)?
    var middleButtonAction: ((_ selected: Bool)->Void)?
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.textColor, forState: .normal)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.disableTextColor, forState: .disabled)
        return button
    }()
    
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.textColor, forState: .normal)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.disableTextColor, forState: .disabled)
        
        let normalImage = ThemeImagePicker(keyPath: "") { _ in
            guard let color = TSPhotoPickerConfig.shared.themeColor.value() as? UIColor else {
                return nil
            }
            let image = UIImage.handy.image(with: color)
            return image
        }
        
        let disabledImage = ThemeImagePicker(keyPath: "") { _ in
            guard let color = TSPhotoPickerConfig.shared.buttonDisableColor.value() as? UIColor else {
                return nil
            }
            let image = UIImage.handy.image(with: color)
            return image
        }
        button.theme.setBackgroundImage(normalImage, forState: .normal)
        button.theme.setBackgroundImage(disabledImage, forState: .disabled)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    lazy var middleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.textColor, forState: .normal)
        button.theme.setTitleColor(TSPhotoPickerConfig.shared.disableTextColor, forState: .disabled)
        button.setImage(TSPhotoPickerTool.getImage(with: "photo_original_normal"), for: .normal)
        button.setImage(TSPhotoPickerTool.getImage(with: "photo_original_select"), for: .selected)
        if let imagePicker = TSPhotoPickerConfig.shared.bottomBarMiddleNormalImage{
            button.theme.setImage(imagePicker, forState: .normal)
        }
        if let imagePicker = TSPhotoPickerConfig.shared.bottomBarMiddleSelectedImage{
            button.theme.setImage(imagePicker, forState: .selected)
        }
        button.imageView?.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    lazy var middleSubLabel: UILabel = {
        let label = UILabel()
        label.theme.textColor = TSPhotoPickerConfig.shared.textColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .black
        setShadowImage(UIImage(), forToolbarPosition: .topAttached)
        initUI()

    }
    
    func initUI(){
        addSubview(leftButton)
        addSubview(doneButton)
        addSubview(middleButton)
        addSubview(middleSubLabel)
        leftButton.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        middleButton.addTarget(self, action: #selector(middleButtonClick), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside)
        
    }
    
    @objc func leftButtonClick(){
        leftButtonAction?()
    }
    @objc func middleButtonClick(){
        middleButton.isSelected = !middleButton.isSelected
        setMiddleButtonAppearance()
        middleButtonAction?(middleButton.isSelected)
    }
    @objc func doneButtonClick(){
        doneButtonAction?()
        
    }
    func setMiddleButtonAppearance(){
        middleButton.imageView?.theme.backgroundColor = middleButton.isSelected ?  TSPhotoPickerConfig.shared.themeColor : ThemeColorPicker(keyPath: "", map: { _ in
            return UIColor.clear
        })
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        leftButton.frame = CGRect.init(x: 15, y: 0, width: 55, height: frame.size.height-HandyApp.safeAreaInsets.bottom)
        let midWidth = middleButton.sizeThatFits(CGSize.init(width: 999, height: 44)).width+10
        middleButton.frame = CGRect.init(x: 0, y: 0, width: midWidth, height: frame.size.height-HandyApp.safeAreaInsets.bottom)
        middleButton.center = CGPoint.init(x: frame.size.width/2, y: middleButton.center.y)
        middleSubLabel.frame = CGRect.init(x: 0, y: frame.size.height-HandyApp.safeAreaInsets.bottom-14, width: 150, height: 12)
        middleSubLabel.center = CGPoint.init(x: frame.size.width/2, y: middleSubLabel.center.y)
        let buttonWidth = doneButton.sizeThatFits(CGSize.init(width: 200, height: 34)).width + 24
        let margin = (frame.size.height-HandyApp.safeAreaInsets.bottom-34)/2
        doneButton.frame = CGRect.init(x: frame.size.width-buttonWidth-15, y: margin, width: buttonWidth, height: 34)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
