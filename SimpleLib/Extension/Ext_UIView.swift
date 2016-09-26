//
//  UIView+BFKit.swift
//  BFKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2016 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit
import QuartzCore

/// This extesion adds some useful functions to UIView
public extension UIView {
    // MARK: - Enums
    
    /**
     Direction of flip animation
     
     - FromTop:    Flip animation from top
     - FromLeft:   Flip animation from left
     - FromRight:  Flip animation from right
     - FromBottom: Flip animation from bottom
     */
    public enum UIViewAnimationFlipDirection: Int {
        case FromTop
        case FromLeft
        case FromRight
        case FromBottom
    }
    
    /**
     Direction of the translation
     
     - FromLeftToRight: Translation from left to right
     - FromRightToLeft: Translation from right to left
     */
    public enum UIViewAnimationTranslationDirection: Int {
        case FromLeftToRight
        case FromRightToLeft
    }
    
    /**
     Direction of the linear gradient
     
     - Vertical:                            Linear gradient vertical
     - Horizontal:                          Linear gradient horizontal
     - DiagonalFromLeftToRightAndTopToDown: Linear gradient from left to right and top to down
     - DiagonalFromLeftToRightAndDownToTop: Linear gradient from left to right and down to top
     - DiagonalFromRightToLeftAndTopToDown: Linear gradient from right to left and top to down
     - DiagonalFromRightToLeftAndDownToTop: Linear gradient from right to left and down to top
     */
    public enum UIViewLinearGradientDirection: Int {
        case Vertical
        case Horizontal
        case DiagonalFromLeftToRightAndTopToDown
        case DiagonalFromLeftToRightAndDownToTop
        case DiagonalFromRightToLeftAndTopToDown
        case DiagonalFromRightToLeftAndDownToTop
    }
    
    // MARK: - Size
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func right() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func bottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setX(x: CGFloat) {
        var rect: CGRect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func setRight(right: CGFloat) {
        var rect: CGRect = self.frame
        rect.origin.x = right - rect.size.width
        self.frame = rect
    }
    
    func setY(y: CGFloat) {
        var rect: CGRect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func setBottom(bottom: CGFloat) {
        var rect: CGRect = self.frame
        rect.origin.y = bottom - rect.size.height
        self.frame = rect
    }
    
    func setWidth(width: CGFloat) {
        var rect: CGRect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func setHeight(height: CGFloat) {
        var rect: CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }
    
    // MARK: - Instance functions
    
    /**
     Create a border around the UIView
     
     - parameter color:  Border's color
     - parameter radius: Border's radius
     - parameter width:  Border's width
     */
    public func createBordersWithColor(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        let cgColor: CGColorRef = color.CGColor
        self.layer.borderColor = cgColor
    }
    
    /**
     Remove the borders around the UIView
     */
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.borderColor = nil
    }
    
    /**
     Remove the shadow around the UIView
     */
    public func removeShadow() {
        self.layer.shadowColor = UIColor.clearColor().CGColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    /**
     Set the corner radius of UIView
     
     - parameter radius: Radius value
     */
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /**
     Set the corner radius of UIView only at the given corner
     
     - parameter corners: Corners to apply radius
     - parameter radius: Radius value
     */
    public func cornerRadius(corners corners: UIRectCorner, radius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).CGPath
        self.layer.mask = rectShape
    }
    
    /**
     Create a shadow on the UIView
     
     - parameter offset:  Shadow's offset
     - parameter opacity: Shadow's opacity
     - parameter radius:  Shadow's radius
     */
    public func createRectShadowWithOffset(offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    /**
     Create a corner radius shadow on the UIView
     
     - parameter cornerRadius: Corner radius value
     - parameter offset:       Shadow's offset
     - parameter opacity:      Shadow's opacity
     - parameter radius:       Shadow's radius
     */
    public func createCornerRadiusShadowWithCornerRadius(cornerRadius: CGFloat, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).CGPath
        self.layer.masksToBounds = false
    }
    
    /**
     Create a linear gradient
     
     - parameter colors:    Array of UIColor instances
     - parameter direction: Direction of the gradient
     */
    public func createGradientWithColors(colors: Array<UIColor>, direction: UIViewLinearGradientDirection) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        
        let mutableColors: NSMutableArray = NSMutableArray(array: colors)
        for i in 0 ..< colors.count {
            let currentColor: UIColor = colors[i]
            mutableColors.replaceObjectAtIndex(i, withObject: currentColor.CGColor)
        }
        gradient.colors = mutableColors as AnyObject as! Array<UIColor>
        
        switch direction {
        case .Vertical:
            gradient.startPoint = CGPointMake(0.5, 0.0)
            gradient.endPoint = CGPointMake(0.5, 1.0)
        case .Horizontal:
            gradient.startPoint = CGPointMake(0.0, 0.5)
            gradient.endPoint = CGPointMake(1.0, 0.5)
        case .DiagonalFromLeftToRightAndTopToDown:
            gradient.startPoint = CGPointMake(0.0, 0.0)
            gradient.endPoint = CGPointMake(1.0, 1.0)
        case .DiagonalFromLeftToRightAndDownToTop:
            gradient.startPoint = CGPointMake(0.0, 1.0)
            gradient.endPoint = CGPointMake(1.0, 0.0)
        case .DiagonalFromRightToLeftAndTopToDown:
            gradient.startPoint = CGPointMake(1.0, 0.0)
            gradient.endPoint = CGPointMake(0.0, 1.0)
        case .DiagonalFromRightToLeftAndDownToTop:
            gradient.startPoint = CGPointMake(1.0, 1.0)
            gradient.endPoint = CGPointMake(0.0, 0.0)
        }
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    /**
     Create a shake effect on the UIView
     */
    public func shakeView() {
        let shake: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [NSValue(CATransform3D: CATransform3DMakeTranslation(-5.0, 0.0, 0.0)), NSValue(CATransform3D: CATransform3DMakeTranslation(5.0, 0.0, 0.0))]
        shake.autoreverses = true
        shake.repeatCount = 2.0
        shake.duration = 0.07
        
        self.layer.addAnimation(shake, forKey: "shake")
    }
    
    /**
     Create a pulse effect on th UIView
     
     - parameter duration: Seconds of animation
     */
    public func pulseViewWithDuration(duration: CGFloat) {
        UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }) { (finished) -> Void in
            if finished {
                UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(0.96, 0.96)
                }) { (finished: Bool) -> Void in
                    if finished {
                        UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
                            self.transform = CGAffineTransformMakeScale(1.03, 1.03)
                        }) { (finished: Bool) -> Void in
                            if finished {
                                UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
                                    self.transform = CGAffineTransformMakeScale(0.985, 0.985)
                                }) { (finished: Bool) -> Void in
                                    if finished {
                                        UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
                                            self.transform = CGAffineTransformMakeScale(1.007, 1.007)
                                        }) { (finished: Bool) -> Void in
                                            if finished {
                                                UIView.animateWithDuration(NSTimeInterval(duration / 6), animations: { () -> Void in
                                                    self.transform = CGAffineTransformMakeScale(1, 1)
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     Create a heartbeat effect on the UIView
     
     - parameter duration: Seconds of animation
     */
    public func heartbeatViewWithDuration(duration: CGFloat) {
        let maxSize: CGFloat = 1.4, durationPerBeat: CGFloat = 0.5
        
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        let scale1: CATransform3D = CATransform3DMakeScale(0.8, 0.8, 1)
        let scale2: CATransform3D = CATransform3DMakeScale(maxSize, maxSize, 1)
        let scale3: CATransform3D = CATransform3DMakeScale(maxSize - 0.3, maxSize - 0.3, 1)
        let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
        
        let frameValues: Array = [NSValue(CATransform3D: scale1), NSValue(CATransform3D: scale2), NSValue(CATransform3D: scale3), NSValue(CATransform3D: scale4)]
        
        animation.values = frameValues
        
        let frameTimes: Array = [NSNumber(float: 0.05), NSNumber(float: 0.2), NSNumber(float: 0.6), NSNumber(float: 1.0)]
        animation.keyTimes = frameTimes
        
        animation.fillMode = kCAFillModeForwards
        animation.duration = NSTimeInterval(durationPerBeat)
        animation.repeatCount = Float(duration / durationPerBeat)
        
        self.layer.addAnimation(animation, forKey: "heartbeat")
    }
    
    /**
     Create a opacity on the UIView
     创建一个持续的闪烁动画
     
     - parameter duration: Seconds of animation
     */
    public func opacityAnimation(duration: CGFloat) {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = 1.0
        opacityAnimation.values = [1.0, 0.6, 0.3]
        opacityAnimation.keyTimes = [0.05, 0.55, 1.0]
        opacityAnimation.removedOnCompletion = false // ?
        self.layer.addAnimation(opacityAnimation, forKey: "opacity")
    }
    
    /**
     Create a twinkle CAAnimationGroup on the UIView
     创建一个持续的闪烁动画 by CAAnimationGroup
     
     - parameter duration: Seconds of animation
     */
    func twinkleViewWithDuration(duration: CGFloat) {
        let durationPerBeat: CGFloat = 0.5
        
        let opaqueAnimate = CABasicAnimation(keyPath: "opacity")
        opaqueAnimate.fromValue = 1.0
        opaqueAnimate.toValue = 0.7
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.7
        alphaAnimation.toValue = 0.3
        
        let group = CAAnimationGroup()
        group.duration = 2.0
        group.repeatCount = Float.infinity
        group.removedOnCompletion = false
        group.animations = [opaqueAnimate, alphaAnimation]
        
        opaqueAnimate.autoreverses = true
        opaqueAnimate.repeatCount = Float(duration / durationPerBeat)
        opaqueAnimate.duration = NSTimeInterval(durationPerBeat)
        
        // layer添加动画
        self.layer.addAnimation(group, forKey: "twinkle")
    }
    
    /**
     Adds a motion effect to the view
     */
    public func applyMotionEffects() {
        let horizontalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -10.0
        horizontalEffect.maximumRelativeValue = 10.0
        let verticalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -10.0
        verticalEffect.maximumRelativeValue = 10.0
        let motionEffectGroup: UIMotionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        self.addMotionEffect(motionEffectGroup)
    }
    
    /**
     Flip the view
     
     - parameter duration:  Seconds of animation
     - parameter direction: Direction of the flip animation
     */
    public func flipWithDuration(duration: NSTimeInterval, direction: UIViewAnimationFlipDirection) {
        var subtype: String = ""
        
        switch (direction) {
        case .FromTop:
            subtype = "fromTop"
        case .FromLeft:
            subtype = "fromLeft"
        case .FromBottom:
            subtype = "fromBottom"
        case .FromRight:
            subtype = "fromRight"
        }
        
        let transition: CATransition = CATransition()
        
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = "flip"
        transition.subtype = subtype
        transition.duration = duration
        transition.repeatCount = 1
        transition.autoreverses = true
        
        self.layer.addAnimation(transition, forKey: "flip")
    }
    
    /**
     Translate the UIView around the topView
     
     - parameter topView:         Top view to translate to
     - parameter duration:        Duration of the translation
     - parameter direction:       Direction of the translation
     - parameter repeatAnimation: If the animation must be repeat or no
     - parameter startFromEdge:   If the animation must start from the edge
     */
    public func translateAroundTheView(topView: UIView, duration: CGFloat, direction: UIViewAnimationTranslationDirection, repeatAnimation: Bool = true, startFromEdge: Bool = true) {
        var startPosition: CGFloat = self.center.x, endPosition: CGFloat
        switch (direction) {
        case .FromLeftToRight:
            startPosition = self.frame.size.width / 2
            endPosition = -(self.frame.size.width / 2) + topView.frame.size.width
        case .FromRightToLeft:
            startPosition = -(self.frame.size.width / 2) + topView.frame.size.width
            endPosition = self.frame.size.width / 2
        }
        
        if startFromEdge {
            self.center = CGPointMake(startPosition, self.center.y)
        }
        
        UIView.animateWithDuration(NSTimeInterval(duration / 2), delay: 1, options: .CurveEaseInOut, animations: { () -> Void in
            self.center = CGPointMake(endPosition, self.center.y)
        }) { (finished: Bool) -> Void in
            if finished {
                UIView.animateWithDuration(NSTimeInterval(duration / 2), delay: 1, options: .CurveEaseInOut, animations: { () -> Void in
                    self.center = CGPointMake(startPosition, self.center.y)
                }) { (finished: Bool) -> Void in
                    if finished {
                        if repeatAnimation {
                            self.translateAroundTheView(topView, duration: duration, direction: direction, repeatAnimation: repeatAnimation, startFromEdge: startFromEdge)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Take a screenshot of the current view
     
     - returns: Returns screenshot as UIImage
     */
    public func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData: NSData = UIImagePNGRepresentation(image)!
        image = UIImage(data: imageData)!
        
        return image
    }
    
    /**
     Take a screenshot of the current view an saving to the saved photos album
     
     - returns: Returns screenshot as UIImage
     */
    public func saveScreenshot() -> UIImage {
        let image: UIImage = self.screenshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        return image
    }
    
    /**
     Removes all subviews from current view
     */
    public func removeAllSubviews() {
        self.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
    }
    
}

// MARK: - Custom UIView Initilizers
extension UIView {
    /// EZSwiftExtensions
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }
    
    /// EZSwiftExtensions, puts padding around the view
    public convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.w - padding * 2, height: superView.h - padding * 2))
    }
    
    /// EZSwiftExtensions - Copies size of superview
    public convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.size))
    }
    
    /**
     Create an UIView with the given frame and background color
     
     - parameter frame:           UIView's frame
     - parameter backgroundColor: UIView's background color
     
     - returns: Returns the created UIView
     */
    public convenience init(frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Frame Extensions
extension UIView {
    
    /// EZSwiftExtensions, add multiple subviews
    public func addSubviews(views: [UIView]) {
        views.forEach { eachView in
            self.addSubview(eachView)
        }
    }
    
    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.x + aView.w
            let newHeight = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    /// EZSwiftExtensions, resizes this view so it fits the largest subview
    public func resizeToFitSubviews(tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth = aView.x + aView.w
                let newHeight = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    /// EZSwiftExtensions
    public func resizeToFitWidth() {
        let currentHeight = self.h
        self.sizeToFit()
        self.h = currentHeight
    }
    
    /// EZSwiftExtensions
    public func resizeToFitHeight() {
        let currentWidth = self.w
        self.sizeToFit()
        self.w = currentWidth
    }
    
    /// EZSwiftExtensions
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var w: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    /// EZSwiftExtensions
    public var h: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    /// EZSwiftExtensions
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    /// EZSwiftExtensions
    public var right: CGFloat {
        get {
            return self.x + self.w
        } set(value) {
            self.x = value - self.w
        }
    }
    
    /// EZSwiftExtensions
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    /// EZSwiftExtensions
    public var bottom: CGFloat {
        get {
            return self.y + self.h
        } set(value) {
            self.y = value - self.h
        }
    }
    
    /// EZSwiftExtensions
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    /// EZSwiftExtensions
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    /// EZSwiftExtensions
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
    
    /// EZSwiftExtensions
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
    
    /// EZSwiftExtensions
    public func leftOffset(offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    /// EZSwiftExtensions
    public func rightOffset(offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    /// EZSwiftExtensions
    public func topOffset(offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    /// EZSwiftExtensions
    public func bottomOffset(offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    /// EZSwiftExtensions
    public func alignRight(offset: CGFloat) -> CGFloat {
        return self.w - offset
    }
    
    /// EZSwiftExtensions
    public func reorderSubViews(reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView).hidden {
                if reorder {
                    let aView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }
    
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// EZSE: Centers view in superview horizontally
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        
        self.x = parentView.w / 2 - self.w / 2
    }
    
    /// EZSE: Centers view in superview vertically
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        
        self.y = parentView.h / 2 - self.h / 2
    }
    
    /// EZSE: Centers view in superview horizontally & vertically
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}

// MARK: - Transform Extensions
extension UIView {
    /// EZSwiftExtensions
    public func setRotationX(x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }
    
    /// EZSwiftExtensions
    public func setRotationY(y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }
    
    /// EZSwiftExtensions
    public func setRotationZ(z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    /// EZSwiftExtensions
    public func setRotation(x x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    /// EZSwiftExtensions
    public func setScale(x x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
    
}

// MARK: - Layer Extensions
extension UIView {
    
    /// EZSwiftExtensions
    public func setCornerRadius(radius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// EZSwiftExtensions
    public func addShadow(offset offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowColor = color.CGColor
        if let r = cornerRadius {
            self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).CGPath
        }
    }
    
    /// EZSwiftExtensions
    public func addBorder(width width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.CGColor
        layer.masksToBounds = true
    }
    
    /// EZSwiftExtensions
    public func addBorderTop(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    
    /// EZSwiftExtensions
    public func addBorderTopWithPadding(size size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding * 2, height: size, color: color)
    }
    
    /// EZSwiftExtensions
    public func addBorderBottom(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    
    /// EZSwiftExtensions
    public func addBorderLeft(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    
    /// EZSwiftExtensions
    public func addBorderRight(size size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    
    /// EZSwiftExtensions
    private func addBorderUtility(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    /// EZSwiftExtensions
    public func drawCircle(fillColor fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = fillColor.CGColor
        shapeLayer.strokeColor = strokeColor.CGColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
    
    /// EZSwiftExtensions
    public func drawStroke(width width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w / 2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
    
    /// EZSwiftExtensions [UIRectCorner.TopLeft, UIRectCorner.TopRight]
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
    
    /// EZSwiftExtensions
    public func roundView() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2
    }
    
}

private let UIViewAnimationDuration: NSTimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

// MARK: - Animation Extensions
extension UIView {
    /// EZSwiftExtensions
    public func spring(animations animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func spring(duration duration: NSTimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(
            UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIViewAnimationOptions.AllowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    /// EZSwiftExtensions
    public func animate(duration duration: NSTimeInterval, animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(duration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func animate(animations animations: (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    /// EZSwiftExtensions
    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self]() -> Void in
            self.setScale(x: 1, y: 1)
            })
    }
    
    /// EZSwiftExtensions
    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self]() -> Void in
            self.setScale(x: 1, y: 1)
            })
    }
    
    /// EZSE: Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(CATransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
            NSValue(CATransform3D: CATransform3DMakeTranslation(5, 0, 0))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7 / 100
        
        self.layer.addAnimation(anim, forKey: nil)
    }
    
}

// MARK: - Render Extensions
extension UIView {
    /// EZSwiftExtensions
    public func toImage () -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0)
        drawViewHierarchyInRect(bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Gesture Extensions
extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    /// EZSwiftExtensions
    public func addTapGesture(tapNumber tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> ())?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions
    public func addSwipeGesture(direction direction: UISwipeGestureRecognizerDirection, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        
        #if os(iOS)
            
            swipe.numberOfTouchesRequired = numberOfTouches
            
        #endif
        
        addGestureRecognizer(swipe)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addSwipeGesture(direction direction: UISwipeGestureRecognizerDirection, numberOfTouches: Int = 1, action: ((UISwipeGestureRecognizer) -> ())?) {
        let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
        addGestureRecognizer(swipe)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions
    public func addPanGesture(target target: AnyObject, action: Selector) {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pan)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addPanGesture(action action: ((UIPanGestureRecognizer) -> ())?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        userInteractionEnabled = true
    }
    
    #if os(iOS)
    
    /// EZSwiftExtensions
    public func addPinchGesture(target target: AnyObject, action: Selector) {
        let pinch = UIPinchGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pinch)
        userInteractionEnabled = true
    }
    
    #endif
    
    #if os(iOS)
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addPinchGesture(action action: ((UIPinchGestureRecognizer) -> ())?) {
        let pinch = BlockPinch(action: action)
        addGestureRecognizer(pinch)
        userInteractionEnabled = true
    }
    
    #endif
    
    /// EZSwiftExtensions
    public func addLongPressGesture(target target: AnyObject, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        addGestureRecognizer(longPress)
        userInteractionEnabled = true
    }
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addLongPressGesture(action action: ((UILongPressGestureRecognizer) -> ())?) {
        let longPress = BlockLongPress(action: action)
        addGestureRecognizer(longPress)
        userInteractionEnabled = true
    }
}

extension UIView {
    /// EZSE: Shakes the view for as many number of times as given in the argument.
    public func shakeViewForTimes(times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(CATransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
            NSValue(CATransform3D: CATransform3DMakeTranslation(5, 0, 0))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7 / 100
        
        self.layer.addAnimation(anim, forKey: nil)
    }
}

extension UIView {
    /// EZSE: Loops until it finds the top root view. //TODO: Add to readme
    func rootView() -> UIView {
        guard let parentView = superview else {
            return self
        }
        return parentView.rootView()
    }
}

