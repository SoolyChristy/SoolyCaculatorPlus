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
    
    /// 获取两个运算符的优先级
    ///
    /// - Parameters:
    ///   - a: 第一个运算符
    ///   - b: 第二个运算符
    /// - Returns: 0: 小于  1：大于  2：等于
    final func getOperatorPrecedence(a: String, b: String) -> Int {
        if (a == "+" || a == "-") && (b == "x" || b == "÷") {
            return 0
        }else if (b == "+" || b == "-") && (a == "x" || a == "÷") {
            return 1
        }else {return 2}
    }
    
    /// 两数运算
    ///
    /// - Parameters:
    ///   - a: a数
    ///   - b: b数
    ///   - operatorType: 运算类型
    /// - Returns: 运算结果
    final func caculate(number1 a: Double, number2 b: Double, type operatorType: String) -> Double {
        switch operatorType {
        case "+":
            return a + b
        case "-":
            return a - b
        case "x":
            return a * b
        case "÷":
            return a / b
        default:
            return 0
        }
    }
    
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
        var bracketNumbers = (numbers as NSArray).subarray(with: NSRange(location: index, length: count + 1)) as! [Double]
        var bracketOperators = (operators as NSArray).subarray(with: NSRange(location: index + 1, length: count)) as! [String]
        
        print("括号内 数字 - \(bracketNumbers)")
        print("括号内 符号 - \(bracketOperators)")
        
        // 使用计算系统计算 括号内 的 运算
        caculateSystem(operators: &bracketOperators, numbers: &bracketNumbers)
        
        // 计算结束后移除 括号内的 操作数 以及 操作符
        numbers.removeSubrange(index...index + count)
        operators.removeSubrange(index...index + count + 1)
        
        // 添加计算结果
        numbers.append(result)
        
        print("括号计算完成后 数字 - \(numbers)")
        print("删除计算完成 符号 - \(operators)")
    }
    
    /// 运算系统
    ///
    /// - Parameters:
    ///   - operators: 操作符数组
    ///   - numbers: 操作数数组
    final func caculateSystem( operators: inout [String], numbers: inout [Double]) {
        
        var result: Double = 0
        while operators.count != 0 {
            if operators.count == 1 {
                result = caculate(number1: numbers[0], number2: numbers[1], type: operators[0])
                self.result = result
                
                return
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
                return
            }
        }
    }
}

// MARK: 功能键逻辑
extension HomeViewController {
    final func acClick() {
        currentNum = ""
        displayString = ""
        cleanData()
        
        textView.text = displayString
    }
    
    final func msClick() {
        if currentNum == "" {
            return
        }
        
        memmory = Double(currentNum)
        
        print("保存成功 - \(currentNum)")
    }
    
    final func mrClick() {
        guard let memory = memmory else {
            return
        }
        
        currentNum = "\(memory)"
        displayString += currentNum
        textView.text = displayString
        
        print("读取成功 - \(currentNum)")
    }
    
    final func mPlusClick() {
        guard let memory = memmory, let displayNum = Double(currentNum) else {
            return
        }
        
        currentNum = "\(memory + displayNum)"
        displayString = currentNum
        textView.text = displayString
    }
    
    final func mMinusClick() {
        guard let memory = memmory, let displayNum = Double(currentNum) else {
            return
        }
        
        currentNum = "\(memory - displayNum)"
        displayString = currentNum
        textView.text = displayString
    }
}
