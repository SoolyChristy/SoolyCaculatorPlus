//
//  HomeViewController+UI.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/28.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  逻辑

import UIKit

// MARK: 计算逻辑
extension HomeViewController {
    
    /// 计算括号里的内容
    final func caculateBracketContents() {
        var index = 0  // 第一个（ 的索引
        var count = 0  // 括号内操作符个数
        for (i,str) in operators.enumerated() {
            if str == "(" {
                index = i
                break
            }
        }
        
        for i in index + 1..<operators.count {
            if operators[i] != ")" {
                count += 1
            }
        }
        
        print("括号内符号个数 - \(count)")
        print("括号索引 - \(index)")
        
        // 获取括号内的 操作数 以及 操作符
        var bracketNumbers = (numbers as NSArray).subarray(with: NSRange(location: index, length: count + 1)) as! [NSDecimalNumber]
        var bracketOperators = (operators as NSArray).subarray(with: NSRange(location: index + 1, length: count)) as! [String]
        
        print("括号内 数字 - \(bracketNumbers)")
        print("括号内 符号 - \(bracketOperators)")
        
        // 使用计算系统计算 括号内 的 运算
        result = CaculateManager.shared.caculateSystem(operators: &bracketOperators, numbers: &bracketNumbers)
        
        // 计算结束后移除 括号内的 操作数 以及 操作符
        numbers.removeSubrange(index...index + count)
        operators.removeSubrange(index...index + count + 1)
        
        // 添加计算结果
        numbers.append(result)
        
        print("括号计算完成后 数字 - \(numbers)")
        print("删除计算完成 符号 - \(operators)")
    }
    
}

