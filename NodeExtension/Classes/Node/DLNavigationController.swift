//
//  DLNavigationController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLNavigationController: ASNavigationController {
    
    public func resetRootViewController(_ rootViewController: UIViewController) {
        self.viewControllers = [rootViewController]
    }

}
