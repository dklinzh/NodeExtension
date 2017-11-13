//
//  DLTextFieldNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 28/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of text field view with right control node
open class DLTextFieldNode: ASDisplayNode {
    // FIXME: @objc
    public let originalNode: DLSimpleTextFieldNode
    
    @objc
    public var rightButtonNode: ASButtonNode?
    
    @objc
    public var insideInsets: UIEdgeInsets {
        get {
            return originalNode.insets
        }
        set {
            originalNode.insets = newValue
        }
    }
    
    @objc
    public var outsideInsets = UIEdgeInsets.zero
    
    @objc
    public var isValidated: Bool {
        return originalNode.isValidated
    }
    
    @objc
    public var text: String? {
        get {
            return self.originalNode.text
        }
        set {
            self.originalNode.text = newValue
        }
    }
    
    // FIXME: @objc
    public init(iconName: String? = nil, placeholder: String, maxLength: UInt = 32, isSecure: Bool = false, clearMode: UITextFieldViewMode = .always, keyboardType: UIKeyboardType? = nil, returnKeyType: UIReturnKeyType? = nil) {
        originalNode = DLSimpleTextFieldNode(iconName: iconName, placeholder: placeholder, maxLength: maxLength, isSecure: isSecure, clearMode: clearMode, keyboardType: keyboardType, returnKeyType: returnKeyType)
        super.init()
        
        self.automaticallyManagesSubnodes = true
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var children = [ASLayoutElement](arrayLiteral: originalNode)
        if let rightButtonNode = rightButtonNode {
            rightButtonNode.style.spacingAfter = outsideInsets.right
            children.append(rightButtonNode)
        } else {
            originalNode.style.spacingAfter = outsideInsets.right / 2
        }
        let horizontalStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: insideInsets.right, justifyContent: .start, alignItems: .center, children: children)
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: outsideInsets.top, left: outsideInsets.left, bottom: outsideInsets.bottom, right: 0), child: horizontalStackSpec)
    }
    
    override open func becomeFirstResponder() -> Bool {
        return originalNode.becomeFirstResponder()
    }
    
    override open func resignFirstResponder() -> Bool {
        return originalNode.resignFirstResponder()
    }
}

/// The Node objcet of simple text field view
// FIXME: @objc
open class DLSimpleTextFieldNode: DLViewNode<DLTextField> {
    
    public var isEditing: Bool {
        return self.nodeView.isEditing
    }
    
    public var isSecureTextEntry: Bool {
        get {
            return self.nodeView.isSecureTextEntry
        }
        set {
            self.appendViewAssociation { (view: DLTextField) in
                view.isSecureTextEntry = newValue
            }
        }
    }
    
    public var text: String? {
        get {
            return self.nodeView.text
        }
        set {
            self.appendViewAssociation { (view: DLTextField) in
                view.text = newValue
            }
        }
    }
    
    public var textColor: UIColor? {
        get {
            return self.nodeView.textColor
        }
        set {
            self.appendViewAssociation { (view: DLTextField) in
                view.textColor = newValue
            }
        }
    }
    
    public var textSize: CGFloat? {
        didSet {
            let _textSize = textSize!
            self.appendViewAssociation { (view: DLTextField) in
                view.font = UIFont.systemFont(ofSize: _textSize)
            }
        }
    }
    
    public var insets: UIEdgeInsets {
        get {
            return self.nodeView.insets
        }
        set {
            self.appendViewAssociation { (view: DLTextField) in
                view.insets = newValue
            }
        }
    }
    
    public var isValidated: Bool {
        var isValidated = validation()
        if isValidated, let appendedValidation = _appendedValidation {
            isValidated = isValidated && appendedValidation()
        }
        if !isValidated {
            //            _ = self.becomeFirstResponder() // FIXME: cause endless loop in iOS 11
        }
        return isValidated
    }
    
    open var validation: () -> Bool {
        return { () -> Bool in
            guard let text = self.text, !text.isEmpty else {
                return false
            }
            
            return true
        }
    }
    
    private var _appendedValidation: (() -> Bool)?
    
    public init(iconName: String? = nil, placeholder: String, maxLength: UInt = 32, isSecure: Bool = false, clearMode: UITextFieldViewMode = .always, keyboardType: UIKeyboardType? = nil, returnKeyType: UIReturnKeyType? = nil) {
        super.init()
        
        self.setViewBlock { () -> UIView in
            let textField = DLTextField()
            
            if let iconName = iconName {
                textField.leftView = UIImageView(image: UIImage.as_imageNamed(iconName))
                textField.leftViewMode = .always
            }
            
            textField.placeholder = placeholder
            textField.maxLength = maxLength
            
            textField.clearButtonMode = clearMode
            if isSecure {
                textField.clearButtonMode = .never
                textField.isSecureTextEntry = true
                textField.keyboardAppearance = .dark
            }
            
            if let keyboardType = keyboardType {
                textField.keyboardType = keyboardType
            }
            
            if let returnKeyType = returnKeyType {
                textField.returnKeyType = returnKeyType
            }
            return textField
        }
        self.style.alignSelf = .stretch
        self.style.flexGrow = 1.0
        self.style.flexShrink = 1.0
    }
    
    override open func becomeFirstResponder() -> Bool {
        return self.nodeView.becomeFirstResponder()
    }
    
    override open func resignFirstResponder() -> Bool {
        return self.nodeView.resignFirstResponder()
    }
    
    public func appendValidation(_ block: @escaping () -> Bool) {
        _appendedValidation = block
    }
}
