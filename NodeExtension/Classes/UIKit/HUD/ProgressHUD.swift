//
//  ProgressHUD.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import MBProgressHUD

extension MBProgressHUD {
    @nonobjc public static var dl_textSize: CGFloat = 12
    
    public static func dl_setTextSize(_ textSize: CGFloat) {
        dl_textSize = textSize
    }
    
    private static let dl_contentMargin: CGFloat = 10
    
    /// Only show text on the view of current UIViewController.
    ///
    /// - Parameter text: The text string to show
    public static func dl_showOnlyText(_ text: String?) {
        guard let superView = UIViewController.dl_topView() else {
            return
        }
        
        dl_showOnlyText(text, superView: superView)
    }
    
    /// Only show text on the super view
    ///
    /// - Parameters:
    ///   - text: The text string to show
    ///   - superView: The super view of hud
    public static func dl_showOnlyText(_ text: String?, superView: UIView) {
        guard let text = text, !text.isEmpty else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        //        hud.offset = CGPoint(x: 0, y: superView.bounds.size.height/3.0)
        hud.margin = dl_contentMargin
        hud.hide(animated: true, afterDelay: 2)
    }
    
    /// Show an indicator on the view of current UIViewController
    public static func dl_showIndicator() {
        guard let superView = UIViewController.dl_topView() else {
            return
        }
        
        dl_showIndicator(superView: superView)
    }
    
    /// Show an indicator on the super view
    ///
    /// - Parameter superView: The super view of hud
    public static func dl_showIndicator(superView: UIView) {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .indeterminate
        hud.margin = dl_contentMargin
    }
    
    /// Hide the indicator have been shown on the view of current UIViewController
    public static func dl_hideHUD() {
        guard let superView = UIViewController.dl_topView() else {
            return
        }
        
        dl_hideHUD(superView: superView)
    }
    
    /// Hide the indicator have been shown on the super view
    ///
    /// - Parameter superView: The super view of hud
    public static func dl_hideHUD(superView: UIView) {
        MBProgressHUD.hide(for: superView, animated: true)
    }
    
    /// Show success hud with message on the view of current UIViewController
    ///
    /// - Parameter text: The successful message
    public static func dl_showSuccess(text: String?) {
        guard let superView = UIViewController.dl_topView() else {
            return
        }
        
        dl_showSuccess(text: text, superView: superView)
    }
    
    /// Show success hud whit message on the super view
    ///
    /// - Parameters:
    ///   - text: The successful message
    ///   - superView: The super view of hud
    public static func dl_showSuccess(text: String?, superView: UIView) {
        guard let text = text, !text.isEmpty else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .customView
        hud.customView = SuccessShapeView()
        hud.label.text = text
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        hud.margin = dl_contentMargin
        hud.hide(animated: true, afterDelay: 2)
    }
    
    /// Show failure hud with message on the view of current UIViewController
    ///
    /// - Parameter text: The failed message
    public static func dl_showFailure(text: String?) {
        guard let superView = UIViewController.dl_topView() else {
            return
        }
        
        dl_showFailure(text: text, superView: superView)
    }
    
    /// Show failure hud whit message on the super view
    ///
    /// - Parameters:
    ///   - text: The failed message
    ///   - superView: The super view of hud
    public static func dl_showFailure(text: String?, superView: UIView) {
        guard let text = text, !text.isEmpty else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .customView
        hud.customView = FailureShapeView()
        hud.label.text = text
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        hud.margin = dl_contentMargin
        hud.hide(animated: true, afterDelay: 3)
    }
    
    /// Show a determinate progress on the view of current UIViewController
    ///
    /// - Returns: HUD instance
    public static func dl_showDeterminateProgress() -> MBProgressHUD? {
        guard let superView = UIViewController.dl_topView() else {
            return nil
        }
        
        return dl_showDeterminateProgress(superView: superView)
    }
    
    /// Show a determinate progress on the super view
    ///
    /// - Parameter superView: The super view of hud
    /// - Returns: HUD instance
    public static func dl_showDeterminateProgress(superView: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .determinate
        hud.margin = dl_contentMargin
        return hud
    }
    
    /// Show a annular progress on the view of current UIViewController
    ///
    /// - Returns: HUD instance
    public static func dl_showAnnularProgress() -> MBProgressHUD? {
        guard let superView = UIViewController.dl_topView() else {
            return nil
        }
        
        return dl_showAnnularProgress(superView: superView)
    }
    
    /// Show a annular progress on the super view
    ///
    /// - Parameter superView: The super view of hud
    /// - Returns: HUD instance
    public static func dl_showAnnularProgress(superView: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .annularDeterminate
        hud.margin = dl_contentMargin
        return hud
    }
}

private class SuccessShapeView: UIView {
    
    var animationDuration: TimeInterval = 1.0
    private let shapeLayer = CAShapeLayer()
    private let shapeFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
    
    override init(frame: CGRect) {
        super.init(frame: shapeFrame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return shapeFrame.size
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            startAnimation()
        }
    }
    
    private func setup() {
        let size = self.frame.size
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let radius = min(size.width/2, size.height/2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 7 / 2), clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round
        
        let tickPath = UIBezierPath()
        tickPath.move(to: CGPoint(x: center.x - radius / 2, y: center.y + radius / 4))
        tickPath.addLine(to: CGPoint(x: center.x, y: center.y + radius / 2))
        tickPath.addLine(to: CGPoint(x: center.x + radius / 2, y: center.y - radius / 3))
        
        circlePath.append(tickPath)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        self.layer.addSublayer(shapeLayer)
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.duration = animationDuration
        animation.fillMode = kCAFillModeForwards
        shapeLayer.add(animation, forKey: nil)
    }
}

private class FailureShapeView: UIView {
    
    var animationDuration: TimeInterval = 1.0
    private let shapeLayer = CAShapeLayer()
    private let shapeFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
    
    override init(frame: CGRect) {
        super.init(frame: shapeFrame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return shapeFrame.size
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            startAnimation()
        }
    }
    
    private func setup() {
        let size = self.frame.size
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let radius = min(size.width/2, size.height/2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 7 / 2), clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round
        
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: center.x + radius / 3, y: center.y - radius / 3))
        rightPath.addLine(to: CGPoint(x: center.x - radius / 3, y: center.y + radius / 3))
        
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: center.x - radius / 3, y: center.y - radius / 3))
        leftPath.addLine(to: CGPoint(x: center.x + radius / 3, y: center.y + radius / 3))
        
        circlePath.append(rightPath)
        circlePath.append(leftPath)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        self.layer.addSublayer(shapeLayer)
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.duration = animationDuration
        animation.fillMode = kCAFillModeForwards
        shapeLayer.add(animation, forKey: nil)
    }
}
