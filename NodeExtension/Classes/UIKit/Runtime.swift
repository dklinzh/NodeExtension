//
//  Runtime.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import Foundation

/// Get class type from the given class name without its module name
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

/// Get class name without its module name from the given class
///
/// - Parameter aClass: The given class
/// - Returns: Class name without its module name
public func DLStringFromClass(_ aClass: Swift.AnyClass) -> String {
    let className = NSStringFromClass(aClass) as NSString
    let range = className.range(of: ".")
    if range.location == NSNotFound {
        return className as String
    }
    
    return className.substring(from: range.location + 1)
}
