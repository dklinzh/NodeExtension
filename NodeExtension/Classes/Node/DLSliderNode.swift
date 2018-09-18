//
//  DLSliderNode.swift
//  NodeExtension
//
//  Created by Linzh on 8/27/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import AsyncDisplayKit

/// The Node object of slider view
open class DLSliderNode: DLViewNode<DLTrackSlider> {
    
    public typealias DLSliderValueChangedBlock = (_ currentValue: Float) -> Void
    
    public var currentValue: Float {
        didSet {
            let _currentValue = currentValue
            self.appendViewAssociation { (view: DLTrackSlider) in
                view.setValue(_currentValue, animated: true)
            }
        }
    }
    
    public var isEnabled: Bool {
        get {
            return self.nodeView.isEnabled
        }
        set {
            self.appendViewAssociation { (view: DLTrackSlider) in
                view.isEnabled = newValue
            }
        }
    }
    
    public var maximumTrackTintColor: UIColor? {
        get {
            return self.nodeView.maximumTrackTintColor
        }
        set {
            self.appendViewAssociation { (view: DLTrackSlider) in
                view.maximumTrackTintColor = newValue
            }
        }
    }
    
    public var minimumTrackTintColor: UIColor? {
        get {
            return self.nodeView.minimumTrackTintColor
        }
        set {
            self.appendViewAssociation { (view: DLTrackSlider) in
                view.minimumTrackTintColor = newValue
            }
        }
    }
    
    public var thumbTintColor: UIColor? {
        get {
            return self.nodeView.thumbTintColor
        }
        set {
            self.appendViewAssociation { (view: DLTrackSlider) in
                view.thumbTintColor = newValue
            }
        }
    }
    
    public func setThumbImage(_ image: UIImage?, for state: UIControl.State) {
        self.appendViewAssociation { (view: DLTrackSlider) in
            view.setThumbImage(image, for: state)
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
        
        self.nodeView.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        self.nodeView.addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    
    @objc private func valueChanged(sender: UISlider) {
        currentValue = roundf(sender.value / _step) * _step
    }
    
    @objc private func touchUpInside(sender: UISlider) {
        _valueChangedBlock(currentValue)
    }
}
