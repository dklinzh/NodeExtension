//
//  DLBadgeNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 21/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of badge view
open class DLBadgeNode: ASControlNode {
    
    @objc
    public var number: UInt = 0 {
        didSet {
            if number == 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
                if number > 99 {
                    _numberTextNode!.attributedText = NSAttributedString.dl_attributedString(string:"99+", fontSize: 12, color: _textColor)
                    self.style.minWidth = ASDimensionMake(30)
                } else {
                    _numberTextNode!.attributedText = NSAttributedString.dl_attributedString(string:"\(number)", fontSize: 12, color: _textColor)
                    if number > 9 {
                        self.style.minWidth = ASDimensionMake(24)
                    } else {
                        self.style.minWidth = ASDimensionMake(16)
                    }
                }
            }
        }
    }
    
    private var _numberTextNode: ASTextNode?
    private var _badgeImageNode: ASImageNode?
    
    private let _textColor: UIColor
    
    @objc
    public init(textColor: UIColor = .white, badgeColor: UIColor = .red) {
        _textColor = textColor
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        let numberTextNode = ASTextNode()
        numberTextNode.isLayerBacked = true
        _numberTextNode = numberTextNode
        
        let badgeImageNode = ASImageNode()
        badgeImageNode.image = UIImage.as_resizableRoundedImage(withCornerRadius: 8, cornerColor: .clear, fill: badgeColor)
        badgeImageNode.isLayerBacked = true
        _badgeImageNode = badgeImageNode
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(CGFloat.infinity, CGFloat.infinity, CGFloat.infinity, CGFloat.infinity), child: _numberTextNode!)
        return ASOverlayLayoutSpec(child: _badgeImageNode!, overlay: insetSpec)
    }
}
