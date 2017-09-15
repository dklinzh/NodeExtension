//
//  DLViewController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit
@available(*, deprecated, message: "Use ASViewController instead.")
open class DLViewController: ASViewController<ASDisplayNode> {
    
    public init() {
        super.init(node: ASDisplayNode())
        
        self.node.automaticallyManagesSubnodes = true
//        self.automaticallyAdjustRangeModeBasedOnViewEvents = true
        
        self.edgesForExtendedLayout = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
