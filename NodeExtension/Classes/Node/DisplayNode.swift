//
//  DisplayNode.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

extension ASDisplayNode {
    
    /// 投影 box-shadow:
    ///
    /// - Parameters:
    ///   - offsetWidth: 水平位移 (point)
    ///   - offsetHeight: 垂直位移 (point)
    ///   - radius: 模糊半径 (point)
    ///   - color: 阴影颜色
    public func dl_setBoxShadow(offsetWidth: CGFloat, offsetHeight: CGFloat, radius: CGFloat, color: UIColor) {
        self.shadowColor = color.cgColor
        self.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        self.shadowRadius = radius
        self.shadowOpacity = 1
    }
}
