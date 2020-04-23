//
//  SettingsViewController.swift
//  TestApplication
//
//  Created by David Pai on 2020/4/22.
//  Copyright © 2020 GrandFunk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var supportDarkModeSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundSwitch.setOn(appDelegate.soundSetting, animated: false)
        supportDarkModeSwitch.setOn(appDelegate.supportDarkMode, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        appDelegate.soundSetting = soundSwitch.isOn
        appDelegate.supportDarkMode = supportDarkModeSwitch.isOn
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let button = sender as? UIButton {
//            let mainPage = segue.destination as? Page1ViewController
//            mainPage?.soundSetting = soundSwitch.isOn
//        }
//    }
    
    @IBAction func switchSound(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "sound")
    }
    
    @IBAction func switchSupportDarkMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "supportDarkMode")
        
        if !sender.isOn {
            if #available(iOS 13.0, *) {
                appDelegate.window?.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            if #available(iOS 13.0, *) {
                appDelegate.window?.overrideUserInterfaceStyle = .unspecified
            } else {
                
            }
        }
    }
}
