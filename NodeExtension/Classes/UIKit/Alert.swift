//
//  Alert.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UIAlertAction {
    
    /// Set the title color of action button
    ///
    /// - Parameter color: The color of button title
    public func dl_setTitleTextColor(_ color: UIColor) {
        self.setValue(color, forKey: "_titleTextColor")
    }
}
