//
//  ViewController.swift
//  SoolyCaculator
//
//  Created by SoolyChristina on 2017/5/27.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  界面 + 交互

import UIKit

class HomeViewController: UIViewController {

    lazy var textView = UITextView()
    lazy var keyboardView = UIView()
    
    /// 当前数字
    var currentNum: String = ""
    /// 当前显示文本
    var displayString: String = ""
    /// 操作数
    var numbers: [Double] = [Double]()
    /// 操作符
    var operators: [String] = [String]()
    /// 运算结果
    var result: Double = 0
    /// MS
    var memmory: Double?
    
    var bracketCount = 0
    var isFinishCaculate: Bool = false
    var isDeleting: Bool = false
    var isBracket: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func cleanData() {
        numbers.removeAll()
        operators.removeAll()
        
        isDeleting = false
        isBracket = false
        currentNum = ""
        displayString = ""
        textView.text = displayString
    }
}

// MARK: 监听方法
fileprivate extension HomeViewController {

    /// 点击功能键
    @objc func functionBtnClick(btn: UIButton) {
        guard let title = btn.titleLabel?.text else {
            return
        }
        
        switch title {
        case "AC":
            acClick()
        case "MS":
            msClick()
        case "MR":
            mrClick()
        case "M+":
            mPlusClick()
        case "M-":
            mMinusClick()
        default:
            return
        }
    }
    
    /// 点击退格键
    @objc func backspaceClick() {
        if displayString == "" {
            return
        }
        
        if isFinishCaculate {
            acClick()
            return
        }
        
        // 获取 当前显示最后一个字符
        let lastCharacter = displayString.lastCharacter()
        
        // 如果 字符为数字
        if Int(lastCharacter) != nil || lastCharacter == "." {
            
            currentNum.removeLastCharacter()
            displayString.removeLastCharacter()
            textView.text = displayString
            
            if isDeleting {
                numbers.removeLast()
                if currentNum == "" {
                    isDeleting = false
                    print("删除后 数字 - \(numbers)")
                    print("删除后 符号 - \(operators)")
                    print("删除后 当前数字 - \(currentNum)")
                    return
                }
                numbers.append(Double(currentNum)!)
            }
            
        } else {
            isDeleting = true
            operators.removeLast()
            currentNum = "\(numbers.last!.doubleToIntegerString())"
            displayString.removeLastCharacter()
            textView.text = displayString
        }
        
        print("删除后 数字 - \(numbers)")
        print("删除后 符号 - \(operators)")
        print("删除后 当前数字 - \(currentNum)")
    }
    
    /// 点击数字键
    @objc func numBtnClick(btn: UIButton) {
       
        if isFinishCaculate {
            isFinishCaculate = false
            
            cleanData()
        }
        
        guard let num = btn.titleLabel?.text else {
            return
        }
        
        currentNum += num
        displayString += num
        
        textView.text = displayString
        
        print("当前数字 - \(currentNum)")
    }
    
    /// 点击符号键
    @objc func operatorBtnClick(btn: UIButton) {
        
        if isFinishCaculate {
            isFinishCaculate = false
            cleanData()
            
            currentNum = result.doubleToIntegerString()
            displayString = result.doubleToIntegerString()
        }
        
        guard let title = btn.titleLabel?.text else {
            return
        }
        
        // 若当前数字为空 则替换已选择的符号
        guard let number = Double(currentNum) else {
            
            if operators.count > 0 {
                operators.removeLast()
                operators.append(title)
                
                displayString.removeLastCharacter()
                displayString += title
                textView.text = displayString
            }
            return
        }
        
        if !isDeleting && !isBracket {
            numbers.append(number)
        }
        currentNum = ""
        operators.append(title)
        
        displayString += "\(title)"
        
        textView.text = displayString
        
        isDeleting = false
        isBracket = false
        
        print("数字 - \(numbers)")
        print("符号 - \(operators)")
    }
    
    /// 点击小数键
    @objc func pointBtnClick() {
        if let _ = currentNum.range(of: ".") {
            return
        }
        
        if currentNum == "" {
            displayString += "0"
        }
        
        currentNum += "."
        displayString += "."
        
        textView.text = displayString
    }
    
    /// 点击括号键
    @objc func bracketsBtnClick() {
        
        if isFinishCaculate {
            return
        }
        
        if bracketCount == 0 {
            displayString += "("
            textView.text = displayString
            
            operators.append("(")
            
            bracketCount += 1
        }else if bracketCount == 1 {
            guard let number = Double(currentNum) else {
                return
            }
            
            numbers.append(number)
            operators.append(")")
            
            displayString += ")"
            textView.text = displayString
            
            caculateBracketContents()
            isBracket = true
            bracketCount -= 1
        }
        
    }
    
    /// 点击等号键
    @objc func equalBtnClick() {
        if numbers.count == 0 {
            return
        }
        
        guard let number = Double(currentNum) else {
            return
        }
        
        if !isDeleting {
            numbers.append(number)
        }
        currentNum = ""
        
        caculateSystem(operators: &operators, numbers: &numbers)
        
        currentNum = result.doubleToIntegerString()
        displayString += " = \(result.doubleToIntegerString())"
        textView.text = displayString
        
        print("计算结束 结果为 - \(result)")
        
        isFinishCaculate = true
        isDeleting = false
    }
}

// MARK: 设置界面
extension HomeViewController {
    fileprivate func setupUI() {
        view.backgroundColor = mainColor
        setupTextView()
        setupKeyboardView()
        setupNumButtons()
        setupOperatorButtons()
        setupFunctionButtons()
    }
    
    /// 数字键
    private func setupNumButtons() {
        let titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        for i in 0..<9 {
            
            let btn = UIButton(title: titles[i])
            
            let row = i / 3
            let column = i % 3
            
            btn.frame = CGRect(x: CGFloat(column) * btnWidth,
                               y: CGFloat(row) * btnHeight + btnHeight,
                               width: btnWidth,
                               height: btnHeight)
            
            btn.addTarget(self, action: #selector(numBtnClick(btn:)), for: .touchUpInside)
            
            keyboardView.addSubview(btn)
        }
        
        // 零
        let zeroBtn = UIButton(title: "0")
        
        zeroBtn.frame = CGRect(x: 0, y: 4 * btnHeight, width: btnWidth * 2, height: btnHeight)
        zeroBtn.addTarget(self, action: #selector(numBtnClick(btn:)), for: .touchUpInside)
        
        keyboardView.addSubview(zeroBtn)
    }
    
    /// 运算符
    private func setupOperatorButtons() {
        let titles = ["+", "-", "x", "÷", "="]
        
        for i in 0..<5 {
            let btn = UIButton(title: titles[i])
            
            btn.frame = CGRect(x: 3 * btnWidth,
                               y: CGFloat(i) * btnHeight,
                               width: btnWidth,
                               height: btnHeight)
            
            if i == 4 {
                btn.addTarget(self, action: #selector(equalBtnClick), for: .touchUpInside)
            }else {
                btn.addTarget(self, action: #selector(operatorBtnClick(btn:)), for: .touchUpInside)
            }
            
            keyboardView.addSubview(btn)
        }
        
        // .
        let pointBtn = UIButton(title: ".")
        
        pointBtn.frame = CGRect(x: 2 * btnWidth, y: 4 * btnHeight, width: btnWidth, height: btnHeight)
        pointBtn.addTarget(self, action: #selector(pointBtnClick), for: .touchUpInside)
        
        keyboardView.addSubview(pointBtn)
        
        // 正负号
        let signBtn = UIButton(title: "+/-")
        
        signBtn.frame = CGRect(x: 2 * btnWidth, y: 0, width: btnWidth, height: btnHeight)
        
        keyboardView.addSubview(signBtn)
    }
    
    /// 功能键
    private func setupFunctionButtons() {
        // MR MC M+ M- AC
        let titles = ["AC", "MS", "MR", "M+", "M-"]
        
        for i in 0..<5 {
            let btn = UIButton(title: titles[i], textFontSize: 25)
            
            btn.frame = CGRect(x: 4 * btnWidth,
                               y: CGFloat(i) * btnHeight,
                               width: btnWidth,
                               height: btnHeight)
            
            btn.addTarget(self, action: #selector(functionBtnClick(btn:)), for: .touchUpInside)
            
            keyboardView.addSubview(btn)
        }
        
        // 退格
        let backspaceBtn = UIButton(title: "退格", textFontSize: 25)
        
        backspaceBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
        backspaceBtn.addTarget(self, action: #selector(backspaceClick), for: .touchUpInside)
        
        keyboardView.addSubview(backspaceBtn)
        
        // 括号
        let bracketsBtn = UIButton(title: "( )")
        
        bracketsBtn.frame = CGRect(x: btnWidth, y: 0, width: btnWidth, height: btnHeight)
        bracketsBtn.addTarget(self, action: #selector(bracketsBtnClick), for: .touchUpInside)
        
        keyboardView.addSubview(bracketsBtn)
    }
    
    private func setupTextView() {
        textView.frame = CGRect(x: 0, y: 20, width: screenWidth, height: screenHeight - 5 * btnHeight - 20)
        textView.backgroundColor = view.backgroundColor
        textView.textColor = UIColor.white
        textView.tintColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 35)
        textView.inputView = UIView(frame: CGRect())
        
        view.addSubview(textView)
        
    }
    
    private func setupKeyboardView() {
        keyboardView.frame = CGRect(x: 0, y: textView.frame.maxY, width: screenWidth, height: screenHeight - textView.frame.height)
        view.addSubview(keyboardView)
        
        keyboardView.layer.shadowRadius = 2.5
        keyboardView.layer.shadowOpacity = 0.5
        keyboardView.layer.shadowOffset = CGSize(width: 0, height: -1.5)
        keyboardView.layer.shadowColor = UIColor.black.cgColor
        
        keyboardView.clipsToBounds = false
    }
}
