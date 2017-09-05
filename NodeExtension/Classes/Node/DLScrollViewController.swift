//
//  DLScrollViewController.swift
//  NodeExtension
//
//  Created by Daniel Lin on 05/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLScrollViewController: ASViewController<ASScrollNode> {
    
    public init() {
        super.init(node: ASScrollNode())
        
        self.node.automaticallyManagesSubnodes = true
        self.node.automaticallyManagesContentSize = true
        
        self.edgesForExtendedLayout = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
