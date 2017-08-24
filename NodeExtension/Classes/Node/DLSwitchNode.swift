//
//  DLSwitchNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 24/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of switch view
public class DLSwitchNode: ASDisplayNode {

    public typealias DLSwitchActionBlock = (_ isOn: Bool) -> Void
    
    public var isEnabled: Bool = true {
        didSet {
            if self.isNodeLoaded {
                switchView.isEnabled = isEnabled
            }
        }
    }
    
    public var isOn: Bool = false {
        didSet {
            if self.isNodeLoaded {
                switchView.isOn = isOn
            }
        }
    }
    
    private var _tintColor: UIColor = .dl_windowTintColor
    public override var tintColor: UIColor! {
        didSet {
            _tintColor = tintColor
            if self.isNodeLoaded {
                switchView.onTintColor = tintColor
            }
        }
    }
    
    private var switchView: UISwitch {
        return self.view as! UISwitch
    }
    
    private let switchActionBlock: DLSwitchActionBlock
    
    public init(scale: CGFloat = 1.0, action: @escaping DLSwitchActionBlock) {
        switchActionBlock = action
        super.init()
        
        self.setViewBlock { () -> UIView in
            let switchView = UISwitch()
            switchView.transform = CGAffineTransform(scaleX: scale, y: scale)
            return switchView
        }
        
        // FIXME: fit size
        self.style.preferredSize = CGSize(width: 51 * scale, height: 31 * scale)
        self.tintColor = _tintColor
        self.backgroundColor = .clear
    }
    
    override public func didLoad() {
        super.didLoad()
        
        switchView.isEnabled = isEnabled
        switchView.isOn = isOn
        switchView.tintColor = _tintColor
        switchView.addTarget(self, action: #selector(switchAction), for: .valueChanged)
    }
    
    @objc private func switchAction(sender: UISwitch) {
        switchActionBlock(sender.isOn)
    }
}
