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
    @IBOutlet weak var hr1: UILabel!
    @IBOutlet weak var min1: UILabel!
    @IBOutlet weak var sec1: UILabel!
    @IBOutlet weak var hr2: UILabel!
    @IBOutlet weak var min2: UILabel!
    @IBOutlet weak var sec2: UILabel!
    
    @IBOutlet weak var hrResult: UILabel!
    @IBOutlet weak var minResult: UILabel!
    @IBOutlet weak var secResult: UILabel!
    
    @IBOutlet weak var addButton: UIButton! // 預設兩列間的 + 按鈕
    @IBOutlet weak var substractButton: UIButton! // 預設兩列間的 - 按鈕
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var focusedLabel: UILabel?
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calculateButton.frame.origin.y = separator.frame.origin.y
        
        addRow(UIButton())
        timeRows[0][0].backgroundColor = self.timeLabelBackgroundColor
        focusedLabel = timeRows[0][0]
        addRow(UIButton())
        
//        self.errorMessage.text = ""
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
        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: true)
        
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
        if timeRows.count > 0 {
            let removeButton = UIButton(type: .system)
            removeButton.setTitle("減列", for: .normal)
            removeButton.setTitleColor(.systemBlue, for: .normal)
            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            removeButton.frame = CGRect(x: 321, y: removeRowButtons.count == 0 ? 46 : self.removeRowButtons[self.removeRowButtons.count - 1].frame.origin.y + 75, width: 41, height: 36)
            removeButton.tag = self.removeRowButtons.count
            removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
            self.view.addSubview(removeButton)
            self.removeRowButtons.append(removeButton)
        }
        
//        print("operatorButtons.count: \(operatorButtons.count), operators.count: \(operators.count), removeRowButtons.count: \(removeRowButtons.count)")
        calculateButton.frame.origin.y = separator.frame.origin.y
    }
    
    @IBAction func removeRow(_ sender: UIButton) {
        let n = sender.tag
        print("Delete Button: \(n)")
        
        // 判斷欲刪之列是不是最後一列，如果不是，就要把刪除之列後面的列往上移
        var shouldMoveUpRemainingRows = false
        if n < self.timeRows.count - 1 {
            shouldMoveUpRemainingRows = true
        }
        
        // 刪除時間欄位
        for (_, label) in self.timeRows[n].enumerated() {
            label.removeFromSuperview()
        }
        self.timeRows.remove(at: n)
        
        // 刪除 + 和 - 按鈕
        self.operatorButtons[(n - 1) * 2 + 1].removeFromSuperview()
        self.operatorButtons[(n - 1) * 2].removeFromSuperview()
        self.operatorButtons.remove(at: (n - 1) * 2 + 1)
        self.operatorButtons.remove(at: (n - 1) * 2)
        // 重新照順序排定每列所選運算元按鈕的 tag
        for (i, operatorButton) in self.operatorButtons.enumerated() {
            operatorButton.tag = i
        }
        self.operators.remove(at: n - 1)
        
        // 刪除減列按鈕
        self.removeRowButtons[n].removeFromSuperview()
        self.removeRowButtons.remove(at: n)
        // 重新照順序排定減列按鈕的 tag
        for (i, removeRowButton) in self.removeRowButtons.enumerated() {
            removeRowButton.tag = i
        }

        //若刪的是中間的列，則下面的列要往上移
        print("operatorButtons.count: \(operatorButtons.count), operators.count: \(operators.count), removeRowButtons.count: \(removeRowButtons.count)")
        if shouldMoveUpRemainingRows {
//            print("n: \(n), timeRows.count - 1: \(timeRows.count - 1)")
            for i in n...self.timeRows.count - 1 {
                self.operatorButtons[(i - 1) * 2].frame.origin.y -= 75
                self.operatorButtons[(i - 1) * 2 + 1].frame.origin.y -= 75

                self.timeRows[i][0].frame.origin.y -= 75
                self.timeRows[i][1].frame.origin.y -= 75
                self.timeRows[i][2].frame.origin.y -= 75

                self.removeRowButtons[i].frame.origin.y -= 75
            }
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: false)
        
        // 調整計算按鈕列
        calculateButton.frame.origin.y = separator.frame.origin.y
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
        if timeRows.count < 2 {
            return
        }
        
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
    
    @IBAction func focus(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
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
    }
    
    @IBAction func inputDigit(_ sender: UIButton) {
        if self.focusedLabel?.text! == "00" {
            self.focusedLabel?.text = ""
        }
        self.focusedLabel?.text! += (sender.titleLabel?.text!)!
    }
    
    
    @IBAction func backspace(_ sender: UIButton) {
        if (self.focusedLabel?.text!.count)! > 0 && Int((self.focusedLabel?.text!)!)! != 0 {
            self.focusedLabel?.text!.removeLast()
        }
        
        if (self.focusedLabel?.text!.count)! == 0 {
            self.focusedLabel?.text = "00"
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        for i in timeRows {
            for j in i {
                j.text = "00"
                j.layer.borderColor = timeLabelBorderColor
            }
        }
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
