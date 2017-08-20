//
//  Navigation.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UINavigationBar {
    
    /// Set some attributes for the navigation bar in global
    ///
    /// - Parameters:
    ///   - barTintColor: The barTintColor of navigation bar
    ///   - tintColor: The tintColor of navigation bar
    ///   - titleColor: The title color of navigation bar
    ///   - titleSize: The title font size of navigaton bar
    public static func dl_setGlobalAttributes(barTintColor: UIColor = .white, tintColor: UIColor = .blue, titleColor: UIColor = .black, titleSize: CGFloat = 16.0) {
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : titleColor,
                                                            NSFontAttributeName: UIFont.systemFont(ofSize: titleSize)]
    }
    
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
        self.titleTextAttributes = [NSForegroundColorAttributeName : titleColor,
                                    NSFontAttributeName: UIFont.systemFont(ofSize: titleSize)]
    }
    
    /// Set the image of BackBarButtonItem in global
    ///
    /// - Parameter image: The image of BackBarButtonItem
    public static func dl_setGlobalBackBarButtonItem(image: UIImage) {
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }
    
    /// Set alpha value of navigation bar background view. It would be transparent while alpha equals 0.
    ///
    /// - Parameter alpha: Range: (0, 1.0)
    public func dl_setBackgroundAlpha(_ alpha: CGFloat) {
        self.setValue(alpha, forKeyPath: "backgroundView.alpha")
    }
}
