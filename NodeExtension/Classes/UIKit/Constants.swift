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

public enum DLScreenInch {
    case iPhone_3_5
    case iPhone_4
    case iPhone_4_7
    case iPhone_5_5
    case iPhone_5_8
    case unspecified
    
    public static func currentDevice() -> DLScreenInch {
        if UIDevice().userInterfaceIdiom != .phone {
            return .unspecified
        }
        
        if UIScreen.main.nativeBounds.width == 640 && UIScreen.main.nativeBounds.height == 960 {
            return .iPhone_3_5
        } else if UIScreen.main.nativeBounds.width == 640 && UIScreen.main.nativeBounds.height == 1136 {
            return .iPhone_4
        } else if UIScreen.main.nativeBounds.width == 750 && UIScreen.main.nativeBounds.height == 1334 {
            return .iPhone_4_7
        } else if UIScreen.main.nativeBounds.width == 1242 && UIScreen.main.nativeBounds.height == 2208 {
            return .iPhone_5_5
        } else if UIScreen.main.nativeBounds.width == 1125 && UIScreen.main.nativeBounds.height == 2436 {
            return .iPhone_5_8
        } else {
            return .unspecified
        }
    }
}

extension UIColor {
    
    /// Tint color of application window
    public static var dl_windowTintColor: UIColor {
        return UIApplication.shared.delegate!.window!!.tintColor
    }
}
