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
    
    public init(direction: ASStackLayoutDirection, color: UIColor = .black, width: CGFloat = 0.5, scale: CGFloat = 0.0) {
        super.init()
        
        self.image = UIImage.as_resizableRoundedImage(withCornerRadius: CGFloat.leastNonzeroMagnitude, cornerColor: color, fill: color, borderColor: nil, borderWidth: 1.0, roundedCorners: .allCorners, scale: scale)
        self.isLayerBacked = true
        self.style.height = ASDimensionMake(width)
        
        switch direction {
        case .vertical:
            self.style.alignSelf = .stretch
        case .horizontal:
            self.style.flexGrow = 1.0
            self.style.flexShrink = 1.0
        @unknown default: break
        }
    }
    
}

/// The Node object of vertical line view
open class DLVerticalLineNode: ASImageNode {
    
    public init(direction: ASStackLayoutDirection, color: UIColor = .black, width: CGFloat = 0.5, scale: CGFloat = 0.0) {
        super.init()
        
        self.image = UIImage.as_resizableRoundedImage(withCornerRadius: CGFloat.leastNonzeroMagnitude, cornerColor: color, fill: color, borderColor: nil, borderWidth: 1.0, roundedCorners: .allCorners, scale: scale)
        self.isLayerBacked = true
        self.style.width = ASDimensionMake(width)
        
        switch direction {
        case .vertical:
            self.style.flexGrow = 1.0
            self.style.flexShrink = 1.0
        case .horizontal:
            self.style.alignSelf = .stretch
        @unknown default: break
        }
    }
    
}
