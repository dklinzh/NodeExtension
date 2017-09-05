//
//  View.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//


// MARK: - UIView+Image
extension UIView {
    
    public func dl_setBackgroundImage(_ image: UIImage) {
        UIGraphicsBeginImageContext(self.frame.size)
        image.draw(in: self.bounds)
        if let _image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            self.backgroundColor = UIColor(patternImage: _image)
        } else {
            UIGraphicsEndImageContext()
        }
    }
}

// MARK: - UIView+Borders
extension UIView {
    
    @objc public enum BorderSide: UInt {
        case top
        case left
        case bottom
        case right
    }
    
    public func dl_createBorder(side: BorderSide, width: CGFloat, color: UIColor, offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> CALayer {
        
        switch side {
        case .top:
            return _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                    y: 0 + offset.top,
                                                    width: self.frame.size.width - offset.left - offset.right,
                                                    height: width), color: color)
            
        case .left:
            return _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                    y: 0 + offset.top,
                                                    width: width,
                                                    height: self.frame.size.height - offset.top - offset.bottom), color: color)
            
        case .bottom:
            return _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                    y: self.frame.size.height - width - offset.bottom,
                                                    width: self.frame.size.width - offset.left - offset.right,
                                                    height: width), color: color)
            
        case .right:
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - width - offset.right,
                                                    y: 0 + offset.top,
                                                    width: width,
                                                    height: self.frame.size.height), color: color)
        }
    }
    
    public func dl_createViewBackedBorder(side: BorderSide, width: CGFloat, color: UIColor, offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> UIView {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: 0 + offset.top,
                                                                            width: self.frame.size.width - offset.left - offset.right,
                                                                            height: width), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: 0 + offset.top,
                                                                            width: width,
                                                                            height: self.frame.size.height - offset.top - offset.bottom), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: self.frame.size.height - width - offset.bottom,
                                                                            width: self.frame.size.width - offset.left - offset.right,
                                                                            height: width), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width - width - offset.right,
                                                                            y: 0 + offset.top,
                                                                            width: width,
                                                                            height: self.frame.size.height - offset.top - offset.bottom), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
        }
    }
    
    public func dl_addBorder(side: BorderSide, width: CGFloat, color: UIColor, offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        switch side {
        case .top:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                   y: 0 + offset.top,
                                                                   width: self.frame.size.width - offset.left - offset.right,
                                                                   height: width), color: color)
            self.layer.addSublayer(border)
            
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                   y: 0 + offset.top,
                                                                   width: width,
                                                                   height: self.frame.size.height - offset.top - offset.bottom), color: color)
            self.layer.addSublayer(border)
            
        case .bottom:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                   y: self.frame.size.height - width - offset.bottom,
                                                                   width: self.frame.size.width - offset.left - offset.right, height: width), color: color)
            self.layer.addSublayer(border)
            
        case .right:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - width - offset.right,
                                                                   y: 0 + offset.top,
                                                                   width: width,
                                                                   height: self.frame.size.height - offset.top - offset.bottom), color: color)
            self.layer.addSublayer(border)
        }
    }
    
    public func dl_addViewBackedBorder(side: BorderSide, width: CGFloat, color: UIColor, offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: 0 + offset.top,
                                                                            width: self.frame.size.width - offset.left - offset.right,
                                                                            height: width), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: 0 + offset.top,
                                                                            width: width,
                                                                            height: self.frame.size.height - offset.top - offset.bottom), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + offset.left,
                                                                            y: self.frame.size.height - width - offset.bottom,
                                                                            width: self.frame.size.width - offset.left - offset.right,
                                                                            height: width), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width - width - offset.right,
                                                                            y: 0 + offset.top,
                                                                            width: width,
                                                                            height: self.frame.size.height - offset.top - offset.bottom), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
        }
    }
    
    private func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    private func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
}
