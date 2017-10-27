//
//  AnimatedSegmentSwitch.swift
//  AnimatedSegmentSwitch
//
//  Created by Tobias Schmid on 09/18/2015.
//  Copyright (c) 2015 Tobias Schmid. All rights reserved.
//
//  Modify by Wangkan on 07/01/2016
//

import UIKit

// MARK: - AnimatedSegmentSwitch

@IBDesignable public class AnimatedSegmentSwitch: UIControl {
    
    // MARK: - Public Properties
    
    public var items: [String] = ["Item 1", "Item 2", "Item 3"] {
        didSet {
            setupLabels()
        }
    }
    
    public private(set) var selectedIndex: Int = 0
    
    public func setSelectedIndex(_ index: Int, animated: Bool) {
        selectedIndex = index
        displayNewSelectedIndex(animated: animated)
    }
    
    public var animationDuration: TimeInterval = 0.5
    public var animationSpringDamping: CGFloat = 0.6
    public var animationInitialSpringVelocity: CGFloat = 0.8
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable public var selectedTitleColor: UIColor = UIColor.black {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable public var titleColor: UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable public var font: UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    public var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var thumbColor: UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    public var thumbCornerRadius: CGFloat! {
        didSet {
            thumbView.layer.cornerRadius = thumbCornerRadius
        }
    }
    
    @IBInspectable public var thumbInset: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate var labels = [UILabel]()
    fileprivate var thumbView = UIView()
    fileprivate var selectedThumbViewFrame: CGRect?
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        setupLabels()
        
        insertSubview(thumbView, at: 0)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(AnimatedSegmentSwitch.pan(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        /// 响应在选中item上的点击动作
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnimatedSegmentSwitch.tap(_:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
        
        panGesture.require(toFail: tapGesture)
    }
    
    private func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = font
            label.textColor = index == 1 ? selectedTitleColor : titleColor
            label.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: thumbInset)
    }
    
    // MARK: - Touch Events
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        if let index = indexAtLocation(location) {
            setSelectedIndex(index, animated: true)
            sendActions(for: .valueChanged)
        }
        return false
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        if let index = indexAtLocation(location) {
            setSelectedIndex(index, animated: true)
            sendActions(for: .touchDown)
        }
        return false
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let location = touch!.location(in: self)
        if let index = indexAtLocation(location) {
            setSelectedIndex(index, animated: true)
            sendActions(for: .touchDown)
        }
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer!) {
        if gesture.state == .began {
            selectedThumbViewFrame = thumbView.frame
        } else if gesture.state == .changed {
            var frame = selectedThumbViewFrame!
            frame.origin.x += gesture.translation(in: self).x
            frame.origin.x = min(frame.origin.x, bounds.width - frame.width)
            thumbView.frame = frame
        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            let location = gesture.location(in: self)
            let index = nearestIndexAtLocation(location)
            setSelectedIndex(index, animated: true)
            sendActions(for: .valueChanged)
        }
    }
    
    @objc func tap(_ gesture: UIPanGestureRecognizer!) {
        sendActions(for: .touchDown)
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius ?? frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = (thumbCornerRadius ?? thumbView.frame.height / 2) - thumbInset
        
        displayNewSelectedIndex(animated: false)
    }
    
    // MARK: - Private - Helpers
    
    private func displayNewSelectedIndex(animated: Bool) {
        for (_, item) in labels.enumerated() {
            item.textColor = titleColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedTitleColor
        
        if animated {
            UIView.animate(withDuration: animationDuration,
                                       delay: 0.0,
                                       usingSpringWithDamping: animationSpringDamping,
                                       initialSpringVelocity: animationInitialSpringVelocity,
                                       options: [],
                                       animations: { self.thumbView.frame = label.frame },
                                       completion: nil)
        } else {
            self.thumbView.frame = label.frame
        }
    }
    
    private func setSelectedColors() {
        for item in labels {
            item.textColor = titleColor
        }
        
        if labels.count > 0 {
            labels[selectedIndex].textColor = selectedTitleColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    private func setFont() {
        for item in labels {
            item.font = font
        }
    }
    
    private func indexAtLocation(_ location: CGPoint) -> Int? {
        var calculatedIndex: Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
                break
            }
        }
        return calculatedIndex
    }
    
    private func nearestIndexAtLocation(_ location: CGPoint) -> Int {
        var calculatedDistances: [CGFloat] = []
        for (index, item) in labels.enumerated() {
            let distance = sqrt(pow(location.x - item.center.x, 2) + pow(location.y - item.center.y, 2))
            calculatedDistances.insert(distance, at: index)
        }
        return calculatedDistances.index(of: calculatedDistances.min()!)!
    }
    
    private func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerated() {
            let topConstraint = NSLayoutConstraint(item: button,
                                                   attribute: NSLayoutAttribute.top,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: mainView,
                                                   attribute: NSLayoutAttribute.top,
                                                   multiplier: 1.0,
                                                   constant: padding)
            
            let bottomConstraint = NSLayoutConstraint(item: button,
                                                      attribute: NSLayoutAttribute.bottom,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: mainView,
                                                      attribute: NSLayoutAttribute.bottom,
                                                      multiplier: 1.0,
                                                      constant: -padding)
            
            var rightConstraint: NSLayoutConstraint!
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutAttribute.right,
                                                     relatedBy: NSLayoutRelation.equal,
                                                     toItem: mainView,
                                                     attribute: NSLayoutAttribute.right,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            } else {
                let nextButton = items[index + 1]
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutAttribute.right,
                                                     relatedBy: NSLayoutRelation.equal,
                                                     toItem: nextButton,
                                                     attribute: NSLayoutAttribute.left,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            }
            
            var leftConstraint: NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutAttribute.left,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutAttribute.left,
                                                    multiplier: 1.0,
                                                    constant: padding)
            } else {
                let prevButton = items[index - 1]
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutAttribute.left,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: prevButton,
                                                    attribute: NSLayoutAttribute.right,
                                                    multiplier: 1.0,
                                                    constant: padding)
                
                let firstItem = items[0]
                let widthConstraint = NSLayoutConstraint(item: button,
                                                         attribute: .width,
                                                         relatedBy: NSLayoutRelation.equal,
                                                         toItem: firstItem,
                                                         attribute: .width,
                                                         multiplier: 1.0,
                                                         constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
}

// MARK: - UIGestureRecognizer Delegate
extension AnimatedSegmentSwitch: UIGestureRecognizerDelegate {
    
    /**
     此方法在gesture recognizer视图转出UIGestureRecognizerStatePossible状态时调用:
     -如果返回NO　则转换到UIGestureRecognizerStateFailed;
     -如果返回YES　则继续识别触摸序列,如传给super
     
     - parameter gestureRecognizer: 传入的手势

     - returns: 手势判断的结果
     */
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture || gestureRecognizer == tapGesture {
            return thumbView.frame.contains(gestureRecognizer.location(in: self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
