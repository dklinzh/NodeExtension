//
//  ASDisplayNode.swift
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
        self.shadowOpacity = 1.0
    }

    /// 根据`minSize`和`maxSize`来限制并返回对应布局的View
    /// - Parameters:
    ///   - minSize: view的最小size
    ///   - maxSize: view的最大size
    /// - Returns: 对应布局的view
    @discardableResult
    public func viewLayoutFits(minSize: CGSize = .zero, maxSize: CGSize) -> UIView {
        let size = self.layoutThatFits(ASSizeRange(min: minSize, max: maxSize)).size
        self.view.frame.size = size
        return self.view
    }

    /// 限制并返回对应布局的View
    /// - Parameter size: view的准确size
    /// - Returns: 对应布局的view
    @discardableResult
    public func viewLayoutFits(size: CGSize) -> UIView {
        return self.viewLayoutFits(minSize: size, maxSize: size)
    }
}
