//
//  ViewController.swift
//  TestApplication
//
//  Created by GrandFunk on 2017/4/27.
//  Copyright © 2017年 GrandFunk. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ViewController : UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var hrLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var hrResult: UILabel!
    @IBOutlet weak var minResult: UILabel!
    @IBOutlet weak var secResult: UILabel!
    
    @IBOutlet weak var addRowButton: UIButton!
    @IBOutlet weak var separatorView: SeparatorView!
    @IBOutlet weak var calculateButton: UIButton!
    
    var removeRowButtons = [UIButton]() // 刪列按鈕
    var operatorButtons = [UIButton]() // 時間列前的 + 和 - 按鈕
    var operators = [Bool]() // 每列選到的運算元，true for +, false for -
    var timeRows = [[UILabel]]()
    
    @IBOutlet weak var smallKeyboard: UIImageView!
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
            
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var focusedLabel: UILabel?
    
    var keyboardPosition: CGPoint?
    
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var addRowTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyLabel: UILabel!
    @IBOutlet weak var dummyTopContraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    
    var focusedBackgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
    var focusedBackgroundColorInDarkMode = UIColor(red: 130 / 255.0, green: 130 / 255.0, blue: 130 / 255.0, alpha: 1.0)
    var timeLabelBorderColor = UIColor.lightGray.cgColor
    var btnBorderColor = UIColor.blue.cgColor

    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        addRow(UIButton())
        focusedLabel = timeRows[0][0]
        timeRows[0][0].backgroundColor = getFocusedBackgroundColor()
        addRow(UIButton())
                
        // For testing purpose only
//        addMultipleRows(numberOfRows: 6)
                
        let keyboardGesture = UILongPressGestureRecognizer(target: self, action: #selector(panKeyboard))
        keyboardGesture.minimumPressDuration = 0.2
        keyboardGesture.allowableMovement = CGFloat.infinity
        keyboard.addGestureRecognizer(keyboardGesture)
        keyboard.isUserInteractionEnabled = true
        view.bringSubviewToFront(keyboard)
        
        smallKeyboard.isHidden = true
        
        // Sound effects
        guard let _ = try? AVAudioSession.sharedInstance().setCategory(.ambient) else {
            print("Failed to set AVAudioSession catergory.")
            return
        }
        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/Sounds/click", ofType: "m4a")!)) else {
            print("Failed to initialize AVAudioPlayer for click sound.")
            return
        }
        guard let player2 = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/Sounds/ding", ofType: "m4a")!)) else {
            print("Failed to initialize AVAudioPlayer for ding sound.")
            return
        }
        audioPlayer = player
        audioPlayer2 = player2
        audioPlayer.prepareToPlay()
        audioPlayer2.prepareToPlay()
        
        // Remember the keyboard position
        NotificationCenter.default.addObserver(self, selector: #selector(restoreKeyboardPosition), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func restoreKeyboardPosition() {
        guard let pos = keyboardPosition else {
            return
        }
        
        keyboard.center = pos
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        focusedLabel?.backgroundColor = getFocusedBackgroundColor()
    }
    
    func layout() {
        self.leftMargin.constant = UIScreen.main.bounds.maxX * 0.1
        viewDidLayoutSubviews()
        
        separatorView.frame.origin.x = hrLabel.frame.minX - 5
        separatorView.frame.size.width = secLabel.frame.maxX - separatorView.frame.origin.x + 5
        hrResult.center.x = hrLabel.center.x
        minResult.center.x = minLabel.center.x
        secResult.center.x = secLabel.center.x
    }
    
    @objc func panKeyboard(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboard.alpha = 0
                let touchPoint = recognizer.location(in: self.view)
                self.smallKeyboard.center = touchPoint
                self.smallKeyboard.isHidden = false
            })
        
        case .ended:
            let touchPoint = recognizer.location(in: self.view)
            self.keyboard.center = touchPoint

            if keyboard.center.x - (keyboard.frame.width / 2) <= UIScreen.main.bounds.minX {
                keyboard.center.x = UIScreen.main.bounds.minX + (keyboard.frame.width / 2)
            }
            
            if keyboard.center.x + (keyboard.frame.width / 2) >= UIScreen.main.bounds.maxX {
                keyboard.center.x = UIScreen.main.bounds.maxX - (keyboard.frame.width / 2)
            }
            
            if keyboard.center.y - (keyboard.frame.height / 2) <= scrollView.frame.minY {
                keyboard.center.y = scrollView.frame.minY + (keyboard.frame.height / 2)
            }
            
            if keyboard.center.y + (keyboard.frame.height / 2) >= UIScreen.main.bounds.maxY {
                keyboard.center.y = UIScreen.main.bounds.maxY - (keyboard.frame.height / 2)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.smallKeyboard.isHidden = true
                self.keyboard.alpha = 0.8
            })
            
            keyboardPosition = keyboard.center
            
        default: break
        }
    }
    
    @IBAction func addRow(_ sender: UIButton) {
        // 增加 + 和 - 按鈕
        if timeRows.count != 0 {
            let operatorRow: [UIButton] = [UIButton(type: .custom), UIButton(type: .custom)]

            if (self.operatorButtons.count == 0) {
                operatorRow[0].frame = CGRect(x: 0, y: 121, width: 25, height: 25) //+
                operatorRow[0].center.x = minLabel.frame.minX
                operatorRow[1].frame = CGRect(x: 0, y: 121, width: 25, height: 25) //-
                operatorRow[1].center.x = minLabel.frame.maxX
            }
            else {
                operatorRow[0].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.y + 75, width: 25, height: 25) //+
                operatorRow[0].center.x = minLabel.frame.minX
                operatorRow[1].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y + 75, width: 25, height: 25) //-
                operatorRow[1].center.x = minLabel.frame.maxX
            }
            
            // 加進 operatorButtons 陣列以及畫面上
            for (i, button) in operatorRow.enumerated() {
                button.setImage(UIImage(named: i == 0 ? "+" : "-"), for: .normal)
                button.layer.borderWidth = i == 0 ? 1 : 0
                button.layer.borderColor = btnBorderColor
                button.tag = operatorButtons.count
                button.addTarget(self, action: #selector(addOrSubstract(_:)), for: .touchUpInside)
                operatorButtons.append(button)
                contentView.addSubview(button)
            }
            operators.append(true)
        }
        
        // 增加時間欄位列
        let lastRowY = self.timeRows.count == 0 ? 80 : self.timeRows[self.timeRows.count - 1][2].frame.origin.y + 75
        let row: [UILabel] = [UILabel(), UILabel(), UILabel()]        
        row[0].frame = CGRect(x: hrLabel.frame.origin.x, y: lastRowY, width: 54, height: 34)
        row[0].center.x = hrLabel.center.x
        row[1].frame = CGRect(x: minLabel.frame.origin.x, y: lastRowY, width: 54, height: 34)
        row[1].center.x = minLabel.center.x
        row[2].frame = CGRect(x: secLabel.frame.origin.x, y: lastRowY, width: 54, height: 34)
        row[2].center.x = secLabel.center.x
        
        // 加進 timeRows 陣列以及畫面上
        for (i, label) in row.enumerated() {
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                label.textColor = .systemGray
            }
            label.text = "00"
            label.font = .systemFont(ofSize: 20)
            label.layer.borderWidth = 1
            label.layer.borderColor = timeLabelBorderColor
            label.textAlignment = .center
            label.tag = self.timeRows.count * 3 + i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus(_:))))
            label.isUserInteractionEnabled = true
            contentView.addSubview(label)
        }
        self.timeRows.append(row)
        
        // 增加減列按鈕
        if timeRows.count > 1 {
            let removeButton = UIButton(type: .system)
            removeButton.setTitle("⤴︎", for: .normal)
            removeButton.setTitleColor(.systemBlue, for: .normal)
            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            removeButton.frame = CGRect(x: addRowButton.frame.origin.x, y: removeRowButtons.count == 0 ? 155 : self.removeRowButtons[self.removeRowButtons.count - 1].frame.origin.y + 75, width: addRowButton.frame.size.width, height: addRowButton.frame.size.height)
            removeButton.tag = self.removeRowButtons.count
            removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
            removeButton.addTarget(self, action: #selector(btnTouchedDown(_:)), for: .touchDown)
            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchCancel)
            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchDragOutside)
            contentView.addSubview(removeButton)
            self.removeRowButtons.append(removeButton)
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: true)
        refeshRemoveButtons()
        
        btnTouchedUp(btn: sender, playSound: true)
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
                    focusedLabel?.backgroundColor = getFocusedBackgroundColor()
                    break
                }
                else {
                    focusedLabel = timeRows[n + 1][i % 3]
                    focusedLabel?.backgroundColor = getFocusedBackgroundColor()
                    break
                }
            }
        }

        btnTouchedUp(btn: sender, playSound: true)
    }

    @IBAction func addOrSubstract(_ sender: UIButton) {
        playSound(player: audioPlayer, soundOn: appDelegate.soundSetting)
        
        if sender.tag % 2 == 0 {
            self.operatorButtons[sender.tag].layer.borderWidth = 1
            self.operatorButtons[sender.tag].layer.borderColor = btnBorderColor
            self.operatorButtons[sender.tag + 1].layer.borderWidth = 0
            self.operators[sender.tag / 2] = true
        }
        else {
            self.operatorButtons[sender.tag - 1].layer.borderWidth = 0
            self.operatorButtons[sender.tag].layer.borderWidth = 1
            self.operatorButtons[sender.tag].layer.borderColor = btnBorderColor
            self.operators[sender.tag / 2] = false
        }
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
        if timeRows.count >= 2 {
            if isAppend {
                self.separatorView.frame.origin.y += 75
                self.hrResult.frame.origin.y = self.separatorView.frame.origin.y + 46
                self.minResult.frame.origin.y = self.separatorView.frame.origin.y + 46
                self.secResult.frame.origin.y = self.separatorView.frame.origin.y + 46
            }
            else {
                self.separatorView.frame.origin.y -= 75
                self.hrResult.frame.origin.y = self.separatorView.frame.origin.y + 46
                self.minResult.frame.origin.y = self.separatorView.frame.origin.y + 46
                self.secResult.frame.origin.y = self.separatorView.frame.origin.y + 46
            }
        }
        
        // 調整計算與加列按鈕位置
        calculateButton.center.y = separatorView.center.y + 2
        calculateButton.center.x = addRowButton.center.x
        
        viewDidLayoutSubviews()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dummyBottomContraint.constant = hrResult.frame.maxY - dummyTopContraint.constant
        if hrResult.frame.maxY <= scrollView.frame.height {
            dummyBottomContraint.constant = scrollView.frame.height - dummyTopContraint.constant
        }
//        print("hrResult.frame.maxY: \(hrResult.frame.maxY)")
//        print("scrollView.frame.height: \(scrollView.frame.height)")
//        print("dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        
        contentView.layoutIfNeeded()
    }
    
    @IBAction func focus(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
        playSound(player: audioPlayer, soundOn: appDelegate.soundSetting)
        
        if label.tag != focusedLabel?.tag {
            for i in self.timeRows {
                for j in i {
                    if j.tag == label.tag {
                        if #available(iOS 13.0, *) {
                            self.focusedLabel?.backgroundColor = .systemBackground
                        } else {
                            self.focusedLabel?.backgroundColor = contentView.backgroundColor
                        }  // Change background color of the previous focused label to default
                        label.backgroundColor = getFocusedBackgroundColor()
                        self.focusedLabel = label
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    @IBAction func moveFocus(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if sender.tag == 0 {
            if self.focusedLabel!.tag > 0 {
                var tmp: UILabel?
                outerLoop: for i in timeRows {
                    for j in i {
                        if j.tag + 1 == self.focusedLabel!.tag { // the new focused label
                            j.backgroundColor = getFocusedBackgroundColor()
                            tmp = j
                        }
                        else if j.tag == self.focusedLabel!.tag { // the previous focused label
                            if #available(iOS 13.0, *) {
                                j.backgroundColor = .systemBackground
                            } else {
                                j.backgroundColor = contentView.backgroundColor
                            }
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
                        if j.tag == self.focusedLabel!.tag { // the previous focused label
                            if #available(iOS 13.0, *) {
                                j.backgroundColor = .systemBackground
                            } else {
                                j.backgroundColor = contentView.backgroundColor
                            }
                        }
                        else if j.tag == self.focusedLabel!.tag + 1 { // the new focused label
                            self.focusedLabel = j
                            j.backgroundColor = getFocusedBackgroundColor()
                            break outerLoop
                        }
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    @IBAction func inputDigit(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if self.focusedLabel?.text! == "00" {
            self.focusedLabel?.text = ""
        }
        self.focusedLabel?.text! += (sender.titleLabel?.text!)!
        
        self.validate(number: focusedLabel!.text!)
    }

    @IBAction func backspace(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if (self.focusedLabel?.text!.count)! > 0 && Int((self.focusedLabel?.text!)!)! != 0 {
            self.focusedLabel?.text!.removeLast()
        }
        
        if (self.focusedLabel?.text!.count)! == 0 {
            self.focusedLabel?.text = "00"
        }
        
        self.validate(number: focusedLabel!.text!)
    }
    
    @IBAction func clear(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        for i in timeRows {
            for j in i {
                j.text = "00"
                j.layer.borderColor = timeLabelBorderColor
            }
        }
        
        self.validate(number: focusedLabel!.text!)
        
        hrResult.text! = "00"
        minResult.text! = "00"
        secResult.text! = "00"
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
    
    @IBAction func calculate(_ sender: UIButton) {
        playSound(player: audioPlayer2, soundOn: appDelegate.soundSetting)
        
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
        
        btnTouchedUp(btn: sender, playSound: false)
    }
    
    @IBAction func btnTouchedDown(_ sender: UIButton) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = btnBorderColor
    }
    
    @IBAction func btnTouchedUp(btn: UIButton, playSound: Bool) {
        btn.layer.borderWidth = 0
        btn.layer.borderColor = nil
        
        if playSound {
            self.playSound(player: audioPlayer, soundOn: appDelegate.soundSetting)
        }
    }
    
    func playSound(player: AVAudioPlayer, soundOn: Bool) {
        if soundOn {
            player.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton {
            btnTouchedUp(btn: button, playSound: true)
        }
    }
    
    @IBAction func backFromSettingsPage(segue: UIStoryboardSegue) {
//        let source = segue.source as? SettingsViewController
    }
    
    func addMultipleRows(numberOfRows: Int) {
        if numberOfRows <= 0 {
            return
        }
        
        for _ in 0...numberOfRows - 1 {
            addRow(UIButton())
        }
    }
    
    func getFocusedBackgroundColor() -> UIColor {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                return focusedBackgroundColorInDarkMode
            }
            else {
                return focusedBackgroundColor
            }
        } else {
            return focusedBackgroundColor
        }
    }
}
