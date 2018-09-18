//
//  TabBar.swift
//  NodeExtension
//
//  Created by Daniel Lin on 05/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

extension UITabBarItem {
    
    public func dl_setTitleText(color: UIColor, fontSize: CGFloat, for state: UIControl.State) {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], for: state)
    }
}
