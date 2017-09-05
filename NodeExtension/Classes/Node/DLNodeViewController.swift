//
//  DLNodeViewController.swift
//  NodeExtension
//
//  Created by Daniel Lin on 05/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

// FIXME: @objc is not supported within extensions of generic classes
@available(*, deprecated, message: "Use ASViewController instead.")
open class DLNodeViewController<NodeType: ASDisplayNode>: ASViewController<ASDisplayNode> {
    
    public init() {
        super.init(node: NodeType())
        
        // ** Automatic Subnode Management (ASM) **
        self.node.automaticallyManagesSubnodes = true
        
//        self.automaticallyAdjustRangeModeBasedOnViewEvents = true
        
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
