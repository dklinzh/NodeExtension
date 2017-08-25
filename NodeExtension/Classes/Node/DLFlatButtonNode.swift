//
//  DLFlatButtonNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 25/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of flat color button view
open class DLFlatButtonNode: ASButtonNode {
    
    public init(normalColor: UIColor = .dl_windowTintColor, highlightedColor: UIColor? = nil, disabledColor: UIColor = .lightGray, cornerRadius: CGFloat = 0) {
        super.init()
        
        let isCornered = cornerRadius > 0
        let normalBackgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : normalColor, fill: normalColor)
        self.setBackgroundImage(normalBackgroundImage, for: .normal)
        
        if let highlightedColor = highlightedColor {
            self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : highlightedColor, fill: highlightedColor), for: .highlighted)
        } else {
            self.setBackgroundImage(normalBackgroundImage.dl_highlightedImage(), for: .highlighted)
        }
        
        self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : disabledColor, fill: disabledColor), for: .disabled)
    }
    
}
