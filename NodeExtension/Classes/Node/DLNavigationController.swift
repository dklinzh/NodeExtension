//
//  DLNavigationController.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLNavigationController: ASNavigationController {
    
    @objc
    public var rootViewController: UIViewController? {
        if self.viewControllers.count == 0 {
            return nil
        }
        
        return self.viewControllers.first
    }
    
    fileprivate var _completionBlock: ((UIViewController) -> Void)?
    fileprivate var _completionViewController: UIViewController?
    fileprivate var _isSwitching = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    @objc
    public func resetRootViewController(_ rootViewController: UIViewController) {
        self.viewControllers = [rootViewController]
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let topViewController = self.topViewController, topViewController.isMember(of: type(of: viewController)) {
            if _isSwitching {
                return
            }
            _isSwitching = true
        }
        
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc
    open func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping (UIViewController) -> Void) {
        _completionViewController = viewController
        _completionBlock = completion
        
        self.pushViewController(viewController, animated: animated)
    }
    
}

// MARK: - UINavigationControllerDelegate
@objc
extension DLNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        _isSwitching = false
        
        self.interactivePopGestureRecognizer?.isEnabled = true
        
        if _completionViewController == viewController {
            _completionBlock?(viewController)
            
            _completionViewController = nil
            _completionBlock = nil
        }
    }
}
