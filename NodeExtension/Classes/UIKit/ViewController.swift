//
//  ViewController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UIViewController {
    
    /// Get the view of current top UIViewController
    ///
    /// - Returns: The view of UIViewController
    public static func dl_topView() -> UIView? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.topViewController?.view
        } else {
            return rootViewController.view
        }
    }
    
    public static func dl_init(className: String) -> UIViewController? {
        guard let classType = DLClassFromString(className) as? UIViewController.Type else {
            return nil
        }
        
        return classType.init()
    }
}
