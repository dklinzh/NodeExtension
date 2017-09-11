//
//  CellNode.swift
//  NodeExtension
//
//  Created by Linzh on 9/10/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

extension ASCellNode {
    
    public func dl_setSelectedBackgroundColor(_ color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        self.selectedBackgroundView = view
    }
}
