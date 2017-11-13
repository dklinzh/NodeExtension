//
//  ProgressHUD.swift
//  NodeExtension
//
//  Created by Linzh on 8/20/17.
//  Copyright (c) 2017 Daniel Lin. All rights reserved.
//

import MBProgressHUD

@objc
extension MBProgressHUD {
    public static var dl_textSize: CGFloat = 12
    public static var dl_textColor: UIColor = .white
    public static var dl_backgroundColor: UIColor = .black
    public static var dl_contentMargin: CGFloat = 10
    public static var dl_successColor: UIColor = .green
    public static var dl_failureColor: UIColor = .red
    public static var dl_successView: UIView?
    public static var dl_failureView: UIView?
    public static var dl_successDismissedDelay: TimeInterval = 2
    public static var dl_failureDismissedDelay: TimeInterval = 3
    
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
        hud.label.textColor = dl_textColor
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        //        hud.offset = CGPoint(x: 0, y: superView.bounds.size.height/3.0)
        hud.margin = dl_contentMargin
        hud.bezelView.backgroundColor = dl_backgroundColor
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
        hud.bezelView.backgroundColor = dl_backgroundColor
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
        hud.customView = dl_successView ?? SuccessShapeView(color: dl_successColor)
        hud.label.text = text
        hud.label.textColor = dl_textColor
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        hud.margin = dl_contentMargin
        hud.bezelView.backgroundColor = dl_backgroundColor
        hud.hide(animated: true, afterDelay: dl_successDismissedDelay)
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
        hud.customView = dl_failureView ?? FailureShapeView(color: dl_failureColor)
        hud.label.text = text
        hud.label.textColor = dl_textColor
        hud.label.font = UIFont.systemFont(ofSize: dl_textSize)
        hud.margin = dl_contentMargin
        hud.bezelView.backgroundColor = dl_backgroundColor
        hud.hide(animated: true, afterDelay: dl_failureDismissedDelay)
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
        hud.bezelView.backgroundColor = dl_backgroundColor
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
        hud.bezelView.backgroundColor = dl_backgroundColor
        return hud
    }
}

public class SuccessShapeView: UIView {
    
    @objc
    public var animationDuration: TimeInterval = 1.0
    private let shapeLayer = CAShapeLayer()
    private let shapeSize: CGSize
    private let shapeColor: UIColor
    
    @objc
    public init(size: CGSize = CGSize(width: 37, height: 37), color: UIColor = .green) {
        shapeSize = size
        shapeColor = color
        super.init(frame: CGRect(origin: CGPoint.zero, size: size))
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return shapeSize
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            startAnimation()
        }
    }
    
    private func setup() {
        let size = self.frame.size
        let width = size.width
        let height = size.height
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width/2, height/2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 7 / 2), clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round
        
        let tickPath = UIBezierPath()
        tickPath.move(to: CGPoint(x: width * 0.28, y: height * 0.53))
        tickPath.addLine(to: CGPoint(x: width * 0.42, y: height * 0.66))
        tickPath.addLine(to: CGPoint(x: width * 0.72, y: height * 0.36))
        
        circlePath.append(tickPath)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = shapeColor.cgColor
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

public class FailureShapeView: UIView {
    
    @objc
    public var animationDuration: TimeInterval = 1.0
    private let shapeLayer = CAShapeLayer()
    private let shapeSize: CGSize
    private let shapeColor: UIColor
    
    @objc
    public init(size: CGSize = CGSize(width: 37, height: 37), color: UIColor = .red) {
        shapeSize = size
        shapeColor = color
        super.init(frame: CGRect(origin: CGPoint.zero, size: size))
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return shapeSize
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            startAnimation()
        }
    }
    
    private func setup() {
        let size = self.frame.size
        let width = size.width
        let height = size.height
        let center = CGPoint(x: width/2, y: height/2)
        let radius = min(width/2, height/2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 7 / 2), clockwise: true)
        circlePath.lineCapStyle = .round
        circlePath.lineJoinStyle = .round
        
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(x: width * 0.666, y: height * 0.333))
        rightPath.addLine(to: CGPoint(x: width * 0.333, y: height * 0.666))
        
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(x: width * 0.333, y: height * 0.333))
        leftPath.addLine(to: CGPoint(x: width * 0.666, y: width * 0.666))
        
        circlePath.append(rightPath)
        circlePath.append(leftPath)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = shapeColor.cgColor
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
