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
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnBackspace: UIButton!
    
    var isAdd = true // 預設的兩列所選到要用的運算元

    var removeRowButtons = [UIButton]() // 刪列按鈕
    var operatorButtons = [UIButton]() // 時間列前的 + 和 - 按鈕
    var operators = [Bool]() // 每列選到的運算元，true for +, false for -
//    var timeRow = [[UITextField]]() // 時間列
    var timeRows = [[UILabel]]()
    
    var timeLabelBavkgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
    var timeLabelBorderColor = UIColor.lightGray.cgColor

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calculateButton.frame.origin.y = separator.frame.origin.y
        
        // Tap gesture recognizers
        let tap = UITapGestureRecognizer(target: self, action: #selector(focus(_:)))

        timeRows = [[hr1, min1, sec1],[hr2, min2, sec2]]
        for i in 0...timeRows.count - 1 {
            for j in 0...2 {
                timeRows[i][j].tag = i * 3 + j
                timeRows[i][j].layer.borderWidth = 1
                timeRows[i][j].layer.borderColor = timeLabelBorderColor
            }
        }
        
        focusedLabel = timeRows[0][0]
        
        self.errorMessage.text = ""
        
        // Gesture recognizer Label
//        hr1.isUserInteractionEnabled = true
//        hr1.addGestureRecognizer(tap)
//        min1.isUserInteractionEnabled = true
//        min1.addGestureRecognizer(tap)
//        sec1.isUserInteractionEnabled = true
//        sec1.addGestureRecognizer(tap)
    }
    
    @IBAction func addOrSubstract(_ sender: UIButton) {
        if sender.titleLabel?.text == "+" {
            if sender.tag != 10000 {
                self.operatorButtons[sender.tag].setTitleColor(.blue, for: .normal)
                self.operatorButtons[sender.tag].backgroundColor = .lightGray
                self.operatorButtons[sender.tag + 1].setTitleColor(.gray, for: .normal)
                self.operatorButtons[sender.tag + 1].backgroundColor = .white
                self.operators[sender.tag / 2] = true
            }
            else {
                self.addButton.setTitleColor(.blue, for: .normal)
                self.addButton.backgroundColor = .lightGray
                self.substractButton.setTitleColor(.gray, for: .normal)
                self.substractButton.backgroundColor = .white
                self.isAdd = true
            }
        }
        else {
            if sender.tag != 10001 {
                self.operatorButtons[sender.tag - 1].setTitleColor(.gray, for: .normal)
                self.operatorButtons[sender.tag - 1].backgroundColor = .white
                self.operatorButtons[sender.tag].setTitleColor(.blue, for: .normal)
                self.operatorButtons[sender.tag].backgroundColor = .lightGray
                self.operators[sender.tag / 2] = false
            }
            else {
                self.addButton.setTitleColor(.gray, for: .normal)
                self.addButton.backgroundColor = .white
                self.substractButton.setTitleColor(.blue, for: .normal)
                self.substractButton.backgroundColor = .lightGray
                self.isAdd = false
            }
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        if !validate() {
            errorMessage.text = "有錯誤，請修正"
            return
        }
        
        errorMessage.text = ""
        for i in timeRows {
            for j in i {
                j.layer.borderColor = timeLabelBorderColor
            }
        }
        
        let hr1 = Int(self.hr1.text!)!
        let min1 = Int(self.min1.text!)!
        let sec1 = Int(self.sec1.text!)!
        let hr2 = Int(self.hr2.text!)!
        let min2 = Int(self.min2.text!)!
        let sec2 = Int(self.sec2.text!)!

        let totalSec1 = hr1 * 3600 + min1 * 60 + sec1
        let totalSec2 = hr2 * 3600 + min2 * 60 + sec2
        
        var totalSec = 0
        if isAdd {
            totalSec = totalSec1 + totalSec2// + totalSecN
        }
        else {
            totalSec = totalSec1 - totalSec2// - totalSecN
        }

        var totalSecN = 0
        
        if timeRows.count > 2 {
            for (i, line) in self.timeRows.enumerated() {
                let hrN = Int(line[0].text!)!
                let minN = Int(line[1].text!)!
                let secN = Int(line[2].text!)!

                totalSecN = hrN * 3600 + minN * 60 + secN
                
                if operators[i] {
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
        let operatorLine: [UIButton] = [UIButton(type: .system), UIButton(type: .system)]

        if (self.operatorButtons.count == 0) {
            operatorLine[0].frame = CGRect(x: self.addButton.frame.origin.x, y: self.addButton.frame.origin.y + 75, width: 30, height: 25) //+
            operatorLine[1].frame = CGRect(x: self.substractButton.frame.origin.x, y: self.substractButton.frame.origin.y + 75, width: 30, height: 25) //-
        }
        else {
            operatorLine[0].frame = CGRect(x: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.x, y: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.y + 75, width: 30, height: 25) //+
            operatorLine[1].frame = CGRect(x: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.x, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y + 75, width: 30, height: 25) //-
        }
        
        // 加進 operatorButtons 陣列以及畫到畫面上
        for (i, button) in operatorLine.enumerated() {
            button.setTitle(i == 0 ? "+" : "-", for: .normal)
            button.setTitleColor(i == 0 ? .systemBlue : .gray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.tag = operatorButtons.count
            button.addTarget(self, action: #selector(addOrSubstract(_:)), for: .touchUpInside)
            operatorButtons.append(button)
            self.view.addSubview(button)
        }
        operators.append(true)
        
        
        // 增加時間欄位列
        let lastRowY = self.timeRows.count == 0 ? self.hr2.frame.origin.y + 75 : self.timeRows[self.timeRows.count - 1][2].frame.origin.y + 75
        let row: [UILabel] = [UILabel(), UILabel(), UILabel()]
        
        row[0].frame = CGRect(x: self.hr2.frame.origin.x, y: lastRowY, width: 54, height: 34)
        row[1].frame = CGRect(x: self.min2.frame.origin.x, y: lastRowY, width: 54, height: 34)
        row[2].frame = CGRect(x: self.sec2.frame.origin.x, y: lastRowY, width: 54, height: 34)
        // 加進 timeRow 陣列以及畫面上
        for label in row {
            label.text = "00"
            label.font = .systemFont(ofSize: 20)
            label.layer.borderWidth = 1
            label.layer.borderColor = timeLabelBorderColor
            label.textAlignment = .center
            self.view.addSubview(label)
        }
        self.timeRows.append(row)
        
        
        // 增加減列按鈕
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("減列", for: .normal)
        removeButton.setTitleColor(.systemBlue, for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        removeButton.frame = CGRect(x: 321, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y, width: 41, height: 36)
        removeButton.tag = self.removeRowButtons.count
        removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
        self.view.addSubview(removeButton)
        self.removeRowButtons.append(removeButton)
        
        calculateButton.frame.origin.y = separator.frame.origin.y
    }
    
    @IBAction func removeRow(_ sender: UIButton) {
        let n = sender.tag

        // 判斷欲刪之列是不是最後一列，如果不是，就要把後面的列往上移
        var shouldMoveUpRemainingRows = false
        if n < self.operators.count - 1 {
            shouldMoveUpRemainingRows = true
        }
        
        // 刪除時間欄位
        for (_, label) in self.timeRows[n].enumerated() {
            label.removeFromSuperview()
        }
        self.timeRows.remove(at: n)
        
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
        if shouldMoveUpRemainingRows {
            for i in n...self.operators.count - 1 {
                self.operatorButtons[i * 2].frame.origin.y -= 75
                self.operatorButtons[i * 2 + 1].frame.origin.y -= 75
                
                self.timeRows[i][0].frame.origin.y -= 75
                self.timeRows[i][1].frame.origin.y -= 75
                self.timeRows[i][2].frame.origin.y -= 75
                
                self.removeRowButtons[i].frame.origin.y -= 75
            }
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: false)
        
        calculateButton.frame.origin.y = separator.frame.origin.y
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
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
                    label.backgroundColor = timeLabelBavkgroundColor
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
                            j.backgroundColor = timeLabelBavkgroundColor
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
                            j.backgroundColor = timeLabelBavkgroundColor
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
    
    func validate() -> Bool {
        var result = true
        
        for (_, line) in self.timeRows.enumerated() {
            for j in 0...2 {
                line[j].backgroundColor = .white
                let value = Int(line[j].text!)!
                if (j == 0 && value >= 24) || (j != 0 && value >= 60) {
                    line[j].layer.borderColor = UIColor.red.cgColor
                    result = false
                }
            }
        }
        
        self.focusedLabel?.backgroundColor = timeLabelBavkgroundColor
        
        return result
    }
}
