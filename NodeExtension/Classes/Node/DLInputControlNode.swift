//
//  DLInputControlNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 25/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLInputControlNode: ASDisplayNode {

    private let actionBlock: (_ sender: UIView) -> Void
    
    private var inputViewButton: DLInputControlButton {
        return self.view as! DLInputControlButton
    }
    
    public init(inputView: UIView, inputAccessoryView: UIView? = nil, action: @escaping (_ sender: UIView) -> Void) {
        actionBlock = action
        super.init()
        
        self.setViewBlock { () -> UIView in
            return DLInputControlButton(inputView: inputView, inputAccessoryView: inputAccessoryView)
        }
    }
    
    override open func didLoad() {
        super.didLoad()
        
        inputViewButton.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
    }
    
    @objc private func touchAction() {
        inputViewButton.becomeFirstResponder()
        
        actionBlock(inputViewButton)
    }
}
