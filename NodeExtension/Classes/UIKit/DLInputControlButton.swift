//
//  DLInputControlButton.swift
//  NodeExtension
//
//  Created by Daniel Lin on 25/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import UIKit

/// A input control button with inputView & inputAccessoryView
open class DLInputControlButton: UIButton {
    
    override open var inputView: UIView {
        return _inputView
    }
    
    override open var inputAccessoryView: UIView? {
        return _inputAccessoryView
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var _inputView: UIView
    private var _inputAccessoryView: UIView?
    
    @objc
    public init(inputView: UIView, inputAccessoryView: UIView? = nil) {
        _inputView = inputView
        _inputAccessoryView = inputAccessoryView
        
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
