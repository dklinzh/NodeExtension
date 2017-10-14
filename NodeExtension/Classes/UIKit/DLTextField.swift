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

    public var insets = UIEdgeInsets.zero
    
    public var maxLength: UInt? {
        didSet {
            if maxLength == 0 {
                return
            }
            
            if !_didAddObserver {
                _didAddObserver = true
                NotificationCenter.default.addObserver(self, selector: #selector(_textFieldDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
            }
        }
    }

    private var _didAddObserver = false
    
    deinit {
        if _didAddObserver {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: self)
        }
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
        var bounds = UIEdgeInsetsInsetRect(bounds, insets)
        
        if let leftView = leftView {
            bounds.origin.x += leftView.frame.width
            bounds.size.width -= leftView.frame.width
        }
        
        if let rightView = rightView {
            bounds.size.width -= rightView.frame.width
        }
        
        if self.clearButtonMode != .never {
            bounds.size.width -= insets.right
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
//            self.text = self.text
        }
    }
}
