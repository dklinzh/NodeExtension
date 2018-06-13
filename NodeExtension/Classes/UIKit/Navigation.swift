//
//  Navigation.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UINavigationBar {
    
    /// Set some attributes for the specified navigation bar
    ///
    /// - Parameters:
    ///   - barTintColor: The barTintColor of navigation bar
    ///   - tintColor: The tintColor of navigation bar
    ///   - titleColor: The title color of navigation bar
    ///   - titleSize: The title font size of navigaton bar
    public func dl_setAttributes(barTintColor: UIColor = .white, tintColor: UIColor = .blue, titleColor: UIColor = .black, titleSize: CGFloat = 16.0) {
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.titleTextAttributes = [NSAttributedStringKey.foregroundColor : titleColor,
                                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: titleSize)]
    }
    
    /// Set the image of BackBarButtonItem
    ///
    /// - Parameter image: The image of BackBarButtonItem
    public func dl_setBackBarButtonItem(image: UIImage) {
        self.backIndicatorImage = image
        self.backIndicatorTransitionMaskImage = image
    }
    
    /// Set alpha value of navigation bar background view. It would be transparent while alpha equals 0.
    ///
    /// - Parameter alpha: Range: (0, 1.0)
    public func dl_setBackgroundAlpha(_ alpha: CGFloat) {
        self.setValue(alpha, forKeyPath: "backgroundView.alpha")
    }
    
    /// Hide the underline images under the navigation bar
    public func dl_hideBarShadowUnderline() {
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: .default)
    }
}

public protocol DLNavigationControllerDelegate {
    
    func navigationConroller(_ navigationConroller: UINavigationController, shouldPop item: UINavigationItem) -> Bool
}

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let items = navigationBar.items,
            self.viewControllers.count < items.count {
            return true
        }
        
        var shouldPop = true
        if let delegate = self.topViewController as? DLNavigationControllerDelegate {
            shouldPop = delegate.navigationConroller(self, shouldPop: item)
        }
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        }
        
        return false
    }
}
