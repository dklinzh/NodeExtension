//
//  Device.swift
//  NodeExtension
//
//  Created by Linzh on 12/10/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.

extension UIDevice {
    
    public enum DLScreenSizeInch {
        case iPhone_3_5
        case iPhone_4
        case iPhone_4_7
        case iPhone_5_5
        case iPhone_5_8
        case iPhone_6_1
        case iPhone_6_5
        case unspecified
    }
    
    public static func dl_currentScreenSize() -> DLScreenSizeInch {
        if UIDevice().userInterfaceIdiom != .phone {
            return .unspecified
        }
        
        let nativeBounds = UIScreen.main.nativeBounds
        switch (nativeBounds.width, nativeBounds.height) {
        case (640, 960):
            return .iPhone_3_5
        case (640, 1136):
            return .iPhone_4
        case (750, 1334):
            return .iPhone_4_7
        case (1242, 2208), (1080, 1920): // Simulator & Device
            return .iPhone_5_5
        case (1125, 2436):
            return .iPhone_5_8
        case (828, 1792):
            return .iPhone_6_1
        case (1242, 2688):
            return .iPhone_6_5
        default:
            return .unspecified
        }
    }
}
