//
//  Runtime.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

/// Get class type from the given class name without its bundle
///
/// - Parameter aClassName: The given class name
/// - Returns: Class type
public func DLClassFromString(_ aClassName: String) -> Swift.AnyClass? {
    guard !aClassName.isEmpty else {
        return nil
    }
    guard let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
        return nil
    }
    
    return NSClassFromString(bundleName + "." + aClassName)
}
