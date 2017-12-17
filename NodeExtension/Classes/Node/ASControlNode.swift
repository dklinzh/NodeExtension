//
//  ASControlNode.swift
//  NodeExtension
//
//  Created by Daniel Lin on 12/09/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

public typealias ControlNodeAction = (_ node: ASControlNode) -> Void

class ControlNodeActionTarget {
    private var _key = 0
    private let _controlAction: ControlNodeAction
    
    
    init(object: Any, controlAction: @escaping ControlNodeAction) {
        _controlAction = controlAction
        objc_setAssociatedObject(object, &_key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func action(node: ASControlNode) {
        _controlAction(node)
    }
}

extension ASControlNode {
    
    /// add action block for particular event.
    ///
    /// - Parameters:
    ///   - events: ASControlNodeEvent
    ///   - action: ASControlNodeEvent action block
    public func dl_addControl(events: ASControlNodeEvent, action: @escaping ControlNodeAction) {
        let target = ControlNodeActionTarget(object: self, controlAction: action)
        self.addTarget(target, action: #selector(ControlNodeActionTarget.action(node:)), forControlEvents: events)
    }
}
