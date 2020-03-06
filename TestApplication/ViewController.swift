//
//  ViewController.swift
//  TestApplication
//
//  Created by GrandFunk on 2017/4/27.
//  Copyright © 2017年 GrandFunk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToPage1(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPage1", sender: nil)
    }

    @IBAction func goToPage2(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toPage2", sender: nil)
    }
}

