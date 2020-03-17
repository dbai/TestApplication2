//
//  Page1ViewController.swift
//  TestApplication
//
//  Created by GrandFunk on 2017/4/27.
//  Copyright © 2017年 GrandFunk. All rights reserved.
//

import Foundation
import UIKit

class Page1ViewController : UIViewController {    
    @IBOutlet weak var hrResult: UILabel!
    @IBOutlet weak var minResult: UILabel!
    @IBOutlet weak var secResult: UILabel!
    
    @IBOutlet weak var addRowButton: UIButton!
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var focusedLabel: UILabel?
    
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnBackspace: UIButton!
    
    var removeRowButtons = [UIButton]() // 刪列按鈕
    var operatorButtons = [UIButton]() // 時間列前的 + 和 - 按鈕
    var operators = [Bool]() // 每列選到的運算元，true for +, false for -
    var timeRows = [[UILabel]]()
    
    var timeLabelBackgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
    var timeLabelBorderColor = UIColor.lightGray.cgColor

    
    var animator: UIDynamicAnimator?
    var snapBehavior: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calculateButton.frame.origin.y = separator.frame.origin.y
        
        addRow(UIButton())
        timeRows[0][0].backgroundColor = self.timeLabelBackgroundColor
        focusedLabel = timeRows[0][0]
        addRow(UIButton())
        
//        self.errorMessage.text = ""
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panKeyboard))
        keyboard.addGestureRecognizer(panGesture)
        keyboard.isUserInteractionEnabled = true
        view.bringSubviewToFront(keyboard)
        
        animator = UIDynamicAnimator(referenceView: view)
        snapBehavior = UISnapBehavior(item: keyboard, snapTo: view.center)
        animator!.addBehavior(snapBehavior!)
    }
    
    @objc func panKeyboard(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                animator!.removeBehavior(snapBehavior!)
            case .changed:
                let translation = recognizer.translation(in: view)
                keyboard.center = CGPoint(x: keyboard.center.x + translation.x, y: keyboard.center.y + translation.y)
                recognizer.setTranslation(.zero, in: view)
            case .ended, .cancelled, .failed:
                animator!.addBehavior(snapBehavior!)
            default:
                break
        }
//        switch recognizer.state {
//            case .changed:
//                let translation = recognizer.translation(in: view)
//                keyboard.center = CGPoint(x: keyboard.center.x + translation.x, y: keyboard.center.y + translation.y)
//                recognizer.setTranslation(.zero, in: view)
//            default: break
//        }
    }
    
    @IBAction func addOrSubstract(_ sender: UIButton) {
        if sender.titleLabel?.text == "+" {
            self.operatorButtons[sender.tag].setTitleColor(.systemBlue, for: .normal)
            self.operatorButtons[sender.tag].backgroundColor = self.timeLabelBackgroundColor
            self.operatorButtons[sender.tag + 1].setTitleColor(.gray, for: .normal)
            self.operatorButtons[sender.tag + 1].backgroundColor = .white
            self.operators[sender.tag / 2] = true
        }
        else {
            self.operatorButtons[sender.tag - 1].setTitleColor(.gray, for: .normal)
            self.operatorButtons[sender.tag - 1].backgroundColor = .white
            self.operatorButtons[sender.tag].setTitleColor(.systemBlue, for: .normal)
            self.operatorButtons[sender.tag].backgroundColor = self.timeLabelBackgroundColor
            self.operators[sender.tag / 2] = false
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
//        if !validate() {
//            errorMessage.text = "有錯誤，請修正"
//            return
//        }
        
//        errorMessage.text = ""
//        for i in timeRows {
//            for j in i {
//                j.layer.borderColor = timeLabelBorderColor
//            }
//        }
        
        var totalSec = 0
        var totalSecN = 0
        
        for (i, row) in self.timeRows.enumerated() {
            let hrN = Int(row[0].text!)!
            let minN = Int(row[1].text!)!
            let secN = Int(row[2].text!)!

            totalSecN = hrN * 3600 + minN * 60 + secN
            
            if i == 0 {
                totalSec = totalSecN
            }
            else {
                if operators[i - 1] {
                    totalSec = totalSec + totalSecN
                }
                else {
                    totalSec = totalSec - totalSecN
                }
            }
        }
                
        let hrResult = totalSec / 3600
        let minResult = (totalSec % 3600) / 60
        let secResult = (totalSec % 3600) % 60
        
        self.hrResult.text = String(format: "%02d", hrResult)
        self.minResult.text = String(format: "%02d", minResult)
        self.secResult.text = String(format: "%02d", secResult)
    }
    
    @IBAction func addRow(_ sender: UIButton) {
        // 增加 + 和 - 按鈕
        if timeRows.count != 0 {
            let operatorRow: [UIButton] = [UIButton(type: .system), UIButton(type: .system)]

            if (self.operatorButtons.count == 0) {
                operatorRow[0].frame = CGRect(x: 129, y: 121, width: 30, height: 25) //+
                operatorRow[1].frame = CGRect(x: 167, y: 121, width: 30, height: 25) //-
            }
            else {
                operatorRow[0].frame = CGRect(x: 129/*self.operatorButtons[self.operatorButtons.count - 2].frame.origin.x*/, y: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.y + 75, width: 30, height: 25) //+
                operatorRow[1].frame = CGRect(x: 167/*self.operatorButtons[self.operatorButtons.count - 1].frame.origin.x*/, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y + 75, width: 30, height: 25) //-
            }
            
            // 加進 operatorButtons 陣列以及畫面上
            for (i, button) in operatorRow.enumerated() {
                button.setTitle(i == 0 ? "+" : "-", for: .normal)
                button.setTitleColor(i == 0 ? .systemBlue : .gray, for: .normal)
                button.backgroundColor = i == 0 ? self.timeLabelBackgroundColor : .white
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                button.tag = operatorButtons.count
                button.addTarget(self, action: #selector(addOrSubstract(_:)), for: .touchUpInside)
                operatorButtons.append(button)
                self.view.addSubview(button)
            }
            operators.append(true)
        }
        
        // 增加時間欄位列
        let lastRowY = self.timeRows.count == 0 ? 80 : self.timeRows[self.timeRows.count - 1][2].frame.origin.y + 75
        let row: [UILabel] = [UILabel(), UILabel(), UILabel()]
        row[0].frame = CGRect(x: 42, y: lastRowY, width: 54, height: 34)
        row[1].frame = CGRect(x: 135, y: lastRowY, width: 54, height: 34)
        row[2].frame = CGRect(x: 232, y: lastRowY, width: 54, height: 34)
        
        // 加進 timeRows 陣列以及畫面上
        for (i, label) in row.enumerated() {
            label.text = "00"
            label.font = .systemFont(ofSize: 20)
            label.layer.borderWidth = 1
            label.layer.borderColor = timeLabelBorderColor
            label.textAlignment = .center
            label.tag = self.timeRows.count * 3 + i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus(_:))))
            label.isUserInteractionEnabled = true
            self.view.addSubview(label)
        }
        self.timeRows.append(row)
        
        // 增加減列按鈕
        if timeRows.count > 1 {
            let removeButton = UIButton(type: .system)
            removeButton.setTitle("減列", for: .normal)
            removeButton.setTitleColor(.systemBlue, for: .normal)
            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            removeButton.frame = CGRect(x: 321, y: removeRowButtons.count == 0 ? 155 : self.removeRowButtons[self.removeRowButtons.count - 1].frame.origin.y + 75, width: 41, height: 36)
            removeButton.tag = self.removeRowButtons.count
            removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
            self.view.addSubview(removeButton)
            self.removeRowButtons.append(removeButton)
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: true)
                
        refeshRemoveButtons()
    }
    
    @IBAction func removeRow(_ sender: UIButton) {
        let n = sender.tag
        
        // 判斷欲刪之列是不是最後一列，如果不是，就要把刪除之列後面的列往上移
        var shouldMoveUpRemainingRows = false
        if n + 1 < self.timeRows.count - 1 {
            shouldMoveUpRemainingRows = true
        }
        
        // 刪除時間欄位
        for (_, label) in self.timeRows[n + 1].enumerated() {
            label.removeFromSuperview()
        }
        self.timeRows.remove(at: n + 1)
        // 重新照順序排定時間欄位的 tag
        
        // 刪除 + 和 - 按鈕
        self.operatorButtons[n * 2 + 1].removeFromSuperview()
        self.operatorButtons[n * 2].removeFromSuperview()
        self.operatorButtons.remove(at: n * 2 + 1)
        self.operatorButtons.remove(at: n * 2)
        // 重新照順序排定每列所選運算元按鈕的 tag
        for (i, operatorButton) in self.operatorButtons.enumerated() {
            operatorButton.tag = i
        }
        self.operators.remove(at: n)
        
        // 刪除減列按鈕
        self.removeRowButtons[n].removeFromSuperview()
        self.removeRowButtons.remove(at: n)
        // 重新照順序排定減列按鈕的 tag
        for (i, removeRowButton) in self.removeRowButtons.enumerated() {
            removeRowButton.tag = i
        }

        //若刪的是中間的列，則下面的列要往上移
//        print("operatorButtons.count: \(operatorButtons.count), operators.count: \(operators.count), removeRowButtons.count: \(removeRowButtons.count), timeRows.count: \(timeRows.count)")
        if shouldMoveUpRemainingRows {
            for i in n + 1...self.timeRows.count - 1 {
                self.operatorButtons[(i - 1) * 2].frame.origin.y -= 75
                self.operatorButtons[(i - 1) * 2 + 1].frame.origin.y -= 75

                self.timeRows[i][0].frame.origin.y -= 75
                self.timeRows[i][1].frame.origin.y -= 75
                self.timeRows[i][2].frame.origin.y -= 75
                self.timeRows[i][0].tag = timeRows[i - 1][0].tag + 3
                self.timeRows[i][1].tag = timeRows[i - 1][1].tag + 3
                self.timeRows[i][2].tag = timeRows[i - 1][2].tag + 3

                self.removeRowButtons[i - 1].frame.origin.y -= 75
            }
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: false)
        
        refeshRemoveButtons()
        
        // 檢查 focusedLabel 是否在要被移除的列中，如果是就把 focusedLabel 往上移一列
        for i in (n + 1) * 3...(n + 1) * 3 + 2 {
            if i == focusedLabel?.tag {
                if n == timeRows.count - 1 { // 是最後一列
                    focusedLabel = timeRows[n][i % 3]
                    focusedLabel?.backgroundColor = timeLabelBackgroundColor
                    break
                }
                else {
                    focusedLabel = timeRows[n + 1][i % 3]
                    focusedLabel?.backgroundColor = timeLabelBackgroundColor
                    break
                }
            }
        }
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
        if timeRows.count >= 2 {
            if isAppend {
                self.separator.frame.origin.y += 75
                self.hrResult.frame.origin.y = self.separator.frame.origin.y + 46
                self.minResult.frame.origin.y = self.separator.frame.origin.y + 46
                self.secResult.frame.origin.y = self.separator.frame.origin.y + 46
            }
            else {
                self.separator.frame.origin.y -= 75
                self.hrResult.frame.origin.y = self.separator.frame.origin.y + 46
                self.minResult.frame.origin.y = self.separator.frame.origin.y + 46
                self.secResult.frame.origin.y = self.separator.frame.origin.y + 46
            }
        }
        
        // 調整計算與加列按鈕位置
        addRowButton.frame.origin.y = separator.frame.origin.y
        calculateButton.frame.origin.y = separator.frame.origin.y + 46
    }
    
    @IBAction func focus(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
        if label.tag != focusedLabel?.tag {
            for i in self.timeRows {
                for j in i {
                    if j.tag == label.tag {
                        self.focusedLabel?.backgroundColor = .white
                        label.backgroundColor = timeLabelBackgroundColor
                        self.focusedLabel = label
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    @IBAction func moveFocus(_ sender: UIButton) {
        if sender.titleLabel?.text == "left" {
            if self.focusedLabel!.tag > 0 {
                var tmp: UILabel?
                outerLoop: for i in timeRows {
                    for j in i {
                        if j.tag + 1 == self.focusedLabel!.tag {
                            j.backgroundColor = timeLabelBackgroundColor
                            tmp = j
                        }
                        else if j.tag == self.focusedLabel!.tag {
                            j.backgroundColor = .white
                            self.focusedLabel = tmp
                            break outerLoop
                        }
                    }
                }
            }
        }
        else {
            var noOfLabel = 0
            for i in timeRows {
                for _ in i {
                    noOfLabel += 1
                }
            }
            if self.focusedLabel!.tag < noOfLabel - 1 {
                outerLoop: for i in timeRows {
                    for j in i {
                        if j.tag == self.focusedLabel!.tag {
                            j.backgroundColor = .white
                        }
                        else if j.tag == self.focusedLabel!.tag + 1 {
                            self.focusedLabel = j
                            j.backgroundColor = timeLabelBackgroundColor
                            break outerLoop
                        }
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    @IBAction func inputDigit(_ sender: UIButton) {
        if self.focusedLabel?.text! == "00" {
            self.focusedLabel?.text = ""
        }
        self.focusedLabel?.text! += (sender.titleLabel?.text!)!
        
        self.validate(number: focusedLabel!.text!)
    }
    
    
    @IBAction func backspace(_ sender: UIButton) {
        if (self.focusedLabel?.text!.count)! > 0 && Int((self.focusedLabel?.text!)!)! != 0 {
            self.focusedLabel?.text!.removeLast()
        }
        
        if (self.focusedLabel?.text!.count)! == 0 {
            self.focusedLabel?.text = "00"
        }
        
        self.validate(number: focusedLabel!.text!)
    }
    
    @IBAction func clear(_ sender: UIButton) {
        for i in timeRows {
            for j in i {
                j.text = "00"
                j.layer.borderColor = timeLabelBorderColor
            }
        }        
    }
    
    func refeshRemoveButtons() {
        if removeRowButtons.count <= 1 {
            for (i, _) in removeRowButtons.enumerated() {
                removeRowButtons[i].isHidden = true
            }
        }
        else {
            for (i, _) in removeRowButtons.enumerated() {
                removeRowButtons[i].isHidden = false
            }
        }
    }
    
    func validate(number: String) {
        btn1.isEnabled = number.count < 3 ? true : false
        btn2.isEnabled = number.count < 3 ? true : false
        btn3.isEnabled = number.count < 3 ? true : false
        btn4.isEnabled = number.count < 3 ? true : false
        btn5.isEnabled = number.count < 3 ? true : false
        btn6.isEnabled = number.count < 3 ? true : false
        btn7.isEnabled = number.count < 3 ? true : false
        btn8.isEnabled = number.count < 3 ? true : false
        btn9.isEnabled = number.count < 3 ? true : false
        btn0.isEnabled = number.count < 3 ? true : false
    }
    
//    func validate() -> Bool {
//        var result = true
//        
//        for (_, line) in self.timeRows.enumerated() {
//            for j in 0...2 {
//                line[j].backgroundColor = .white
//                let value = Int(line[j].text!)!
//                if (j == 0 && value >= 24) || (j != 0 && value >= 60) {
//                    line[j].layer.borderColor = UIColor.red.cgColor
//                    result = false
//                }
//            }
//        }
//        
//        self.focusedLabel?.backgroundColor = timeLabelBackgroundColor
//        
//        return result
//    }
}
