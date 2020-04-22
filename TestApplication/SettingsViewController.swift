//
//  SettingsViewController.swift
//  TestApplication
//
//  Created by David Pai on 2020/4/22.
//  Copyright © 2020 GrandFunk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var soundSetting = true
    @IBOutlet weak var soundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        soundSetting = UserDefaults.standard.bool(forKey: "sound")
        soundSwitch.setOn(soundSetting, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton {
            if button.tag == 1 {
                let mainPage = segue.destination as? Page1ViewController
                mainPage?.soundSetting = soundSetting
//                print("Sound saved \(mainPage?.soundSetting)")
            }
        }
    }
    
    @IBAction func switchSound(_ sender: UISwitch) {
        soundSetting = sender.isOn
//        print("Sound set to \(soundSetting)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
