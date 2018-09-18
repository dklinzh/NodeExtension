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
        return dl_topViewController()?.view
    }
    
    public static func dl_topViewController(rootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        var topViewController = rootViewController
        var presentedViewController = rootViewController.presentedViewController
        while presentedViewController != nil {
            topViewController = presentedViewController!
            presentedViewController = topViewController.presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            return dl_topViewController(rootViewController: navigationController.topViewController)
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            return dl_topViewController(rootViewController: tabBarController.selectedViewController)
        }
        
        if topViewController.children.count > 0 {
            return dl_topViewController(rootViewController:topViewController.children[0])
        }
        
        return topViewController
    }
    
    public static func dl_rootViewController() -> UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        return rootViewController
    }
    
    public static func dl_init(className: String) -> UIViewController? {
        guard let classType = DLClassFromString(className) as? UIViewController.Type else {
            return nil
        }
        
        return classType.init()
    }
    
    public func dl_hideNavigationBackTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
