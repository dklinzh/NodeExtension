//
//  DLTrackSlider.swift
//  NodeExtension
//
//  Created by Daniel Lin on 25/08/2017.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import UIKit

open class DLTrackSlider: UISlider {
    
    private var _trackHeight: CGFloat
    
    @objc
    public init(trackHeight: CGFloat = 1.0) {
        _trackHeight = trackHeight
        
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = _trackHeight
        return rect
    }

}
