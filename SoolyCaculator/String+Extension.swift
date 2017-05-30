//
//  String+Extension.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/29.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

extension String {
    /// 移除最后一个字符
    mutating func removeLastCharacter() {
        remove(at: index(before: endIndex))
    }
    
    /// 获取最后一个字符
    func lastCharacter() -> String {
        let index = self.index(self.endIndex, offsetBy: -1)
        return substring(from: index)
    }
}
