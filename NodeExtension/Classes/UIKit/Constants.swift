//
//  Constants.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

public struct DLFrameSize {
    
    /// The scaled value of screen
    public static let screenScale: CGFloat = UIScreen.main.scale
    
    /// The width of screen
    public static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    /// The height of screen
    public static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    /// The height of status bar
    public static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    
}

extension UIColor {
    
    /// Tint color of application window
    public static var dl_windowTintColor: UIColor {
        return UIApplication.shared.delegate!.window!!.tintColor
    }
}
