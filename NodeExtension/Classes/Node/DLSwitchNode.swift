//
//  DLSwitchNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 24/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of switch view
// FIXME: @objc
open class DLSwitchNode: DLViewNode<UISwitch> {

    public typealias DLSwitchActionBlock = (_ isOn: Bool) -> Void
    
    public var isEnabled: Bool {
        get {
            return self.nodeView.isEnabled
        }
        set {
            self.appendViewAssociation { (view: UISwitch) in
                view.isEnabled = newValue
            }
        }
    }
    
    public var isOn: Bool {
        get {
            return self.nodeView.isOn
        }
        set {
            self.appendViewAssociation { (view: UISwitch) in
                view.isOn = newValue
            }
        }
    }
    
    open override var tintColor: UIColor! {
        didSet {
            let _tintColor = tintColor
            self.appendViewAssociation { (view: UISwitch) in
                view.onTintColor = _tintColor
            }
        }
    }
    
    private let _switchActionBlock: DLSwitchActionBlock
    
    public init(scale: CGFloat = 1.0, action: @escaping DLSwitchActionBlock) {
        _switchActionBlock = action
        super.init()
        
        self.setViewBlock { () -> UIView in
            let switchView = UISwitch()
            switchView.transform = CGAffineTransform(scaleX: scale, y: scale)
            return switchView
        }
        
        // FIXME: fit size
        self.style.preferredSize = CGSize(width: 51 * scale, height: 31 * scale)
        self.tintColor = .dl_windowTintColor
        self.backgroundColor = .clear
    }
    
    override open func didLoad() {
        super.didLoad()
        
        self.nodeView.addTarget(self, action: #selector(switchAction), for: .valueChanged)
    }
    
    @objc private func switchAction(sender: UISwitch) {
        _switchActionBlock(sender.isOn)
    }
}
