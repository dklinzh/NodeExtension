//
//  DLNavigationController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLNavigationController: ASNavigationController {
    
    public var rootViewController: UIViewController? {
        if self.viewControllers.count == 0 {
            return nil
        }
        
        return self.viewControllers.first
    }
    
    fileprivate var completionBlock: ((UIViewController) -> Void)?
    fileprivate var completionViewController: UIViewController?
    fileprivate var isSwitching = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    public func resetRootViewController(_ rootViewController: UIViewController) {
        self.viewControllers = [rootViewController]
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.topViewController!.isMember(of: type(of: viewController)) {
            if isSwitching {
                return
            }
            isSwitching = true
        }
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        super.pushViewController(viewController, animated: animated)
    }
    
    open func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping (UIViewController) -> Void) {
        completionViewController = viewController
        completionBlock = completion
        
        self.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension DLNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isSwitching = false
        
        self.interactivePopGestureRecognizer?.isEnabled = true
        
        if completionViewController == viewController {
            completionBlock?(viewController)
            
            completionViewController = nil
            completionBlock = nil
        }
    }
}
