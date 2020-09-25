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
    
    public init(normalColor: UIColor, highlightedColor: UIColor? = nil, selectedColor: UIColor? = nil, disabledColor: UIColor = .lightGray, cornerRadius: CGFloat = 0) {
        super.init()
        
        let isCornered = cornerRadius > 0
        let normalBackgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : normalColor, fill: normalColor, traitCollection: ASPrimitiveTraitCollectionMakeDefault())
        self.setBackgroundImage(normalBackgroundImage, for: .normal)
        
        if let highlightedColor = highlightedColor {
            self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : highlightedColor, fill: highlightedColor, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .highlighted)
        } else {
            self.setBackgroundImage(normalBackgroundImage.dl_highlightedImage(), for: .highlighted)
        }
        
        if let selectedColor = selectedColor {
            self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : selectedColor, fill: selectedColor, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .selected)
        }
        
        self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : disabledColor, fill: disabledColor, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .disabled)
    }
    
    public init(isFilled: Bool, borderColor: UIColor? = nil, borderWidth: CGFloat = 0.5, normalColor: UIColor, highlightedColor: UIColor? = nil, selectedColor: UIColor? = nil, disabledColor: UIColor = .lightGray, cornerRadius: CGFloat = 0) {
        super.init()
        
        let isCornered = cornerRadius > 0
        let normalBackgroundImage = UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : normalColor, fill: isFilled ? normalColor : .clear,
                                                                     borderColor: borderColor ?? normalColor, borderWidth: borderWidth, traitCollection: ASPrimitiveTraitCollectionMakeDefault())
        self.setBackgroundImage(normalBackgroundImage, for: .normal)
        
        if let highlightedColor = highlightedColor {
            self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : highlightedColor, fill: isFilled ? highlightedColor : .clear,
                                                                     borderColor: borderColor ?? highlightedColor, borderWidth: borderWidth, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .highlighted)
        } else {
            self.setBackgroundImage(normalBackgroundImage.dl_highlightedImage(), for: .highlighted)
        }
        
        if let selectedColor = selectedColor {
            self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : selectedColor, fill: isFilled ? selectedColor : .clear,
                                                                     borderColor: borderColor ?? selectedColor, borderWidth: borderWidth, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .selected)
        }
        
        self.setBackgroundImage(UIImage.as_resizableRoundedImage(withCornerRadius: cornerRadius, cornerColor: isCornered ? .clear : disabledColor, fill: isFilled ? disabledColor : .clear,
                                                                 borderColor: borderColor ?? disabledColor, borderWidth: borderWidth, traitCollection: ASPrimitiveTraitCollectionMakeDefault()), for: .disabled)
    }

}
