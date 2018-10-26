//
//  Constants.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

public struct DLFrameSize {
    
    /// The scaled value of screen
    public static let screenScale = UIScreen.main.scale
    
    /// The width of screen
    public static let screenWidth = UIScreen.main.bounds.size.width
    
    /// The height of screen
    public static let screenHeight = UIScreen.main.bounds.size.height
    
    /// The height of status bar
    public static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    /// The top edge inset value of safe area.
    @available(iOS 11.0, *)
    public static let safeAreaTopInset = UIApplication.shared.keyWindow!.safeAreaInsets.top
    
    /// The bottom edge inset value of safe area.
    @available(iOS 11.0, *)
    public static let safeAreaBottomInset = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
    
}

extension UIColor {
    
    /// Tint color of application window. NOTE: Can only be invoked in main thread.
    public static var dl_windowTintColor: UIColor {
        return UIApplication.shared.delegate!.window!!.tintColor
    }
}
