//
//  DLLineNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 24/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of horizontal line view
open class DLHorizontalLineNode: ASImageNode {
    
    @objc
    public init(direction: ASStackLayoutDirection, color: UIColor = .black, width: CGFloat = 0.5) {
        super.init()
        
        self.image = UIImage.as_resizableRoundedImage(withCornerRadius: 0, cornerColor: .clear, fill: color)
        self.isLayerBacked = true
        self.style.height = ASDimensionMake(width)
        
        switch direction {
        case .vertical:
            self.style.alignSelf = .stretch
        case .horizontal:
            self.style.flexGrow = 1.0
            self.style.flexShrink = 1.0
        }
    }
    
}

/// The Node object of vertical line view
open class DLVerticalLineNode: ASImageNode {
    
    @objc
    public init(direction: ASStackLayoutDirection, color: UIColor = .black, width: CGFloat = 0.5) {
        super.init()
        
        self.image = UIImage.as_resizableRoundedImage(withCornerRadius: 0, cornerColor: .clear, fill: color)
        self.isLayerBacked = true
        self.style.width = ASDimensionMake(width)
        
        switch direction {
        case .vertical:
            self.style.flexGrow = 1.0
            self.style.flexShrink = 1.0
        case .horizontal:
            self.style.alignSelf = .stretch
        }
    }
    
}
