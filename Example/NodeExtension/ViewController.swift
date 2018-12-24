//
//  ViewController.swift
//  NodeExtension
//
//  Created by Linzh on 08/20/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import UIKit
import NodeExtension
import MBProgressHUD

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("DLScreenSizeInch: \(UIDevice.dl_currentScreenSize())")
        MBProgressHUD.dl_showIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

