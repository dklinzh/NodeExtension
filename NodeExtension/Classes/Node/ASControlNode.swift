//
//  ASControlNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 12/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

public typealias ControlAction = (_ node: ASControlNode) -> Void

class ControlActionTarget {
    private var _key = 0
    private let _controlAction: ControlAction
    
    
    init(object: Any, controlAction: @escaping ControlAction) {
        _controlAction = controlAction
        objc_setAssociatedObject(object, &_key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func action(node: ASControlNode) {
        _controlAction(node)
    }
}

extension ASControlNode {
    
    public func dl_addControl(events: ASControlNodeEvent, action: @escaping ControlAction) {
        let target = ControlActionTarget(object: self, controlAction: action)
        self.addTarget(target, action: #selector(ControlActionTarget.action(node:)), forControlEvents: events)
    }
}
