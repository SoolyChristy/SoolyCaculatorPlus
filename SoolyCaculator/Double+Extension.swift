//
//  Double+Extension.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/29.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

extension Double {
    /// 如果值为整数 则 返回 整数字符串
    /// 1.0 => 1 , 3.0 => 3
    func doubleToIntegerString() -> String {
        var str = "\(self)"
        
        let patern = ".0$"
        guard let regx = try? NSRegularExpression(pattern: patern, options: []),
            let _ = regx.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count)) else {
                return str
        }
        
        str.removeLastCharacter()
        str.removeLastCharacter()
        
        return str
    }
}
