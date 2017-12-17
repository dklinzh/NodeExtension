//
//  ViewController.swift
//  NodeExtension
//
//  Created by Linzh on 08/20/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import UIKit
import NodeExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 0, height: 0))
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.dl_addControl(events: .touchUpInside) { (sender) in
            debugPrint("sender: \(sender)")
        }
        button.sizeToFit()
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

