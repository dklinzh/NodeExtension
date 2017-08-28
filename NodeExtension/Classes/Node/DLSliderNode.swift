//
//  DLSliderNode.swift
//  NodeExtension
//
//  Created by Linzh on 8/27/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

open class DLSliderNode: ASDisplayNode {
    
    public typealias DLSliderValueChangedBlock = (_ currentValue: Float) -> Void
    
    public var sliderView: DLTrackSlider {
        return self.view as! DLTrackSlider
    }
    
    private var _currentValue: Float = 0
    public var currentValue: Float {
        didSet {
            _currentValue = currentValue
            if self.isNodeLoaded {
                sliderView.setValue(currentValue, animated: true)
            }
        }
    }
    
    private var _isEnabled: Bool = true
    public var isEnabled: Bool = true {
        didSet {
            _isEnabled = isEnabled
            if self.isNodeLoaded {
                sliderView.isEnabled = isEnabled
            }
        }
    }
    
    private var _step: Float
    private var _valueChangedBlock: DLSliderValueChangedBlock

    public init(trackHeight: CGFloat = 1.0, minValue: Float, maxValue: Float, step: Float, valueChanged: @escaping DLSliderValueChangedBlock) {
        _step = step
        _valueChangedBlock = valueChanged
        currentValue = minValue
        super.init()
        
        self.setViewBlock { () -> UIView in
            let sliderView = DLTrackSlider(trackHeight: trackHeight)
            sliderView.minimumValue = minValue
            sliderView.maximumValue = maxValue
            sliderView.isContinuous = true
            return sliderView
        }
        self.style.flexGrow = 1
        self.style.minHeight = ASDimensionMake(34)
    }
    
    open override func didLoad() {
        super.didLoad()
        
        currentValue = _currentValue
        isEnabled = _isEnabled
        sliderView.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        sliderView.addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    
    @objc private func valueChanged(sender: UISlider) {
        currentValue = roundf(sender.value / _step) * _step
    }
    
    @objc private func touchUpInside(sender: UISlider) {
        _valueChangedBlock(currentValue)
    }
}
