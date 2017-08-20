//
//  DLViewController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLViewController: ASViewController<ASDisplayNode> {
    
    public var hidesBackTitle = false
    
    public init() {
        super.init(node: ASDisplayNode())
        
        // ** Automatic Subnode Management (ASM) **
        self.node.automaticallyManagesSubnodes = true
        
//        self.automaticallyAdjustRangeModeBasedOnViewEvents = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if hidesBackTitle {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        self.edgesForExtendedLayout = []
    }

}
