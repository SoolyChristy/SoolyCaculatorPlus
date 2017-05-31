//
//  UIButton+Extension.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String,
                     textColor: UIColor = .black,
                     textFontSize: CGFloat = 30,
                     bgColor: UIColor = .white) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont(name: "PingFangSC-Light", size: textFontSize)
        
        backgroundColor = bgColor
        setBackgroundImage(UIImage.image(withColor: mainColor), for: .highlighted)
    }
    
}
