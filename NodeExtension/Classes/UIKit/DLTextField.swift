//
//  DLTextField.swift
//  NodeExtension
//
//  Created by Daniel Lin on 28/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import UIKit

/// The basic view of TextField
open class DLTextField: UITextField {

    public var textInsets = UIEdgeInsets.zero
    public var leftInset: CGFloat = 0
    
    public var maxLength: UInt? {
        didSet {
            if maxLength == 0 {
                return
            }
            
            if !_didAddObserver {
                _didAddObserver = true
                NotificationCenter.default.addObserver(self, selector: #selector(_textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: self)
            }
        }
    }

    private var _didAddObserver = false
    
    deinit {
        if _didAddObserver {
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: self)
        }
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftInset
        return rect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return adjustRectForLeftView(bounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return adjustRectForLeftView(bounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return adjustRectForLeftView(bounds: bounds)
    }
    
    private func adjustRectForLeftView(bounds: CGRect) -> CGRect {
        var bounds = bounds.inset(by: textInsets)
        
        if let leftView = leftView {
            let leftWidth = leftView.frame.width + leftInset
            bounds.origin.x += leftWidth
            bounds.size.width -= leftWidth
        }
        
        if let rightView = rightView {
            bounds.size.width -= rightView.frame.width
        }
        
        if self.clearButtonMode != .never {
            bounds.size.width -= textInsets.right
        }
        
        return bounds
    }
    
    @objc private func _textFieldDidChange(notification: Notification) {
        let lang = (notification.object as! UIResponder).textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            guard let selectedRange = self.markedTextRange else {
                substringWithinMaxLength()
                return
            }
            
            if self.position(from: selectedRange.start, offset: 0) == nil {
                substringWithinMaxLength()
                return
            }
            
        } else {
            substringWithinMaxLength()
        }
    }
    
    private func substringWithinMaxLength() {
        guard let text = self.text as NSString? else {
            return
        }
        
        let maxLength = Int(self.maxLength!)
        if text.length > maxLength {
            let rangeIndex = text.rangeOfComposedCharacterSequence(at: maxLength)
            if rangeIndex.length == 1 {
                self.text = text.substring(to: maxLength)
            } else {
                let range = text.rangeOfComposedCharacterSequences(for: NSMakeRange(0, maxLength))
                self.text = text.substring(with: range)
            }
        } else {
            self.text = self.text
        }
    }
}
