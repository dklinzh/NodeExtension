//
//  UIControl.swift
//  NodeExtension
//
//  Created by Linzh on 12/17/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.

import UIKit

public typealias ControlAction = (_ sender: UIControl) -> Void

class ControlActionTarget {
    private var _key = 0
    private let _controlAction: ControlAction
    
    
    init(object: Any, controlAction: @escaping ControlAction) {
        _controlAction = controlAction
        objc_setAssociatedObject(object, &_key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func action(sender: UIControl) {
        _controlAction(sender)
    }
}

extension UIControl {
    
    /// add action block for particular event.
    ///
    /// - Parameters:
    ///   - events: UIControlEvents
    ///   - action: UIControl action blcok
    public func dl_addControl(events: UIControl.Event, action: @escaping ControlAction) {
        let target = ControlActionTarget(object: self, controlAction: action)
        self.addTarget(target, action: #selector(ControlActionTarget.action(sender:)), for: events)
    }
}
