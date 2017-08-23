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

import Foundation

public func DLClassFromString(_ aClassName: String) -> Swift.AnyClass? {
    guard !aClassName.isEmpty else {
        return nil
    }
    guard let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
        return nil
    }
    
    return NSClassFromString(bundleName + "." + aClassName)
}

public func DLStringFromClass(_ aClass: Swift.AnyClass) -> String {
    let className = NSStringFromClass(aClass) as NSString
    let range = className.range(of: ".")
    if range.location == NSNotFound {
        return className as String
    }
    
    return className.substring(from: range.location + 1)
}
