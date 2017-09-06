//
//  DLIconTextNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 06/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLIconTextNode: ASButtonNode {

    public init(iconName: String? = nil, contentSpacing: CGFloat = 8.0, isUserInteractionEnabled: Bool = false) {
        super.init()
        
        if let iconName = iconName {
            self.setImage(UIImage.as_imageNamed(iconName), for: .normal)
        }
        self.contentSpacing = contentSpacing
        self.contentHorizontalAlignment = .left
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    public func setTitle(_ title: String, fontSize: CGFloat = 14, color: UIColor? = nil) {
        self.setTitle(title, with: UIFont.systemFont(ofSize: fontSize), with: color, for: .normal)
    }
    
    public func setIconName(_ iconName: String?) {
        self.setImage(iconName != nil ? UIImage.as_imageNamed(iconName!) : nil, for: .normal)
    }
}
