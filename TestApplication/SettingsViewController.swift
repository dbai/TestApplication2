//
//  SettingsViewController.swift
//  TestApplication
//
//  Created by David Pai on 2020/4/22.
//  Copyright © 2020 GrandFunk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var page1ViewController: Page1ViewController?
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundSwitch.setOn(UserDefaults.standard.bool(forKey: "sound"), animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        page1ViewController?.soundSetting = soundSwitch.isOn
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
}
