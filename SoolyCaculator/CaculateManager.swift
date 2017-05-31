//
//  CaculateManager.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/30.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

struct CaculateManager {

    static let shared = CaculateManager()
    
    /// 两数运算
    ///
    /// - Parameters:
    ///   - a: a数
    ///   - b: b数
    ///   - operatorType: 运算类型
    /// - Returns: 运算结果
    func caculate(number1 a: NSDecimalNumber, number2 b: NSDecimalNumber, type operatorType: String) -> NSDecimalNumber {
        switch operatorType {
        case "+":
            return a.adding(b)
        case "-":
            return a.subtracting(b)
        case "x":
            return a.multiplying(by: b)
        case "÷":
            return a.dividing(by: b)
        default:
            return 0
        }
    }
    
    /// 获取两个运算符的优先级
    ///
    /// - Parameters:
    ///   - a: 第一个运算符
    ///   - b: 第二个运算符
    /// - Returns: 0: 小于  1：大于  2：等于
    func getOperatorPrecedence(a: String, b: String) -> Int {
        if (a == "+" || a == "-") && (b == "x" || b == "÷") {
            return 0
        }else if (b == "+" || b == "-") && (a == "x" || a == "÷") {
            return 1
        }else {return 2}
    }

    /// 运算系统
    ///
    /// - Parameters:
    ///   - operators: 操作符数组
    ///   - numbers: 操作数数组
    func caculateSystem( operators: inout [String], numbers: inout [NSDecimalNumber]) -> NSDecimalNumber {
        
        var result: NSDecimalNumber = 0
        while operators.count != 0 {
            if operators.count == 1 {
                result = caculate(number1: numbers[0], number2: numbers[1], type: operators[0])
                
                return result
            }
            
            /// 操作符优先级
            let precedence = getOperatorPrecedence(a: operators[0], b: operators[1])
            
            switch precedence {
            case 0:
                result = caculate(number1: numbers[1], number2: numbers[2], type: operators[1])
                
                numbers.removeSubrange(1...2)
                numbers.insert(result, at: 1)
                
                operators.remove(at: 1)
                
            case 1,2:
                result = caculate(number1: numbers[0], number2: numbers[1], type: operators[0])
                
                numbers.removeSubrange(0...1)
                numbers.insert(result, at: 0)
                
                operators.remove(at: 0)
            default:
                break
            }
        }
        
        return result
    }
}
