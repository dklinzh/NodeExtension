//
//  DLInputControlNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 25/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLInputControlNode: DLViewNode<DLInputControlButton> {

    private let _actionBlock: (_ sender: UIView) -> Void
    
    public init(inputView: UIView, inputAccessoryView: UIView? = nil, action: @escaping (_ sender: UIView) -> Void) {
        _actionBlock = action
        super.init()
        
        self.setViewBlock { () -> UIView in
            return DLInputControlButton(inputView: inputView, inputAccessoryView: inputAccessoryView)
        }
    }
    
    public init(inputViewBlock: @escaping () -> UIView, inputAccessoryViewBlock: (() -> UIView?)? = nil, action: @escaping (_ sender: UIView) -> Void) {
        _actionBlock = action
        super.init()
        
        self.setViewBlock { () -> UIView in
            return DLInputControlButton(inputView: inputViewBlock(), inputAccessoryView: inputAccessoryViewBlock?())
        }
    }
    
    override open func didLoad() {
        super.didLoad()
        
        self.nodeView.addTarget(self, action: #selector(touchAction), for: .touchUpInside)
    }
    
    @objc private func touchAction() {
        _actionBlock(self.nodeView)
        
        self.nodeView.becomeFirstResponder()
    }
}
