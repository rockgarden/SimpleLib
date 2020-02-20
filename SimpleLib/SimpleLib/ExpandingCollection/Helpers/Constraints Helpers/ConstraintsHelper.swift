//
//  ConstraintsHelper.swift
//  ExpandingCollection
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

struct ConstraintInfo {
    var attribute: NSLayoutConstraint.Attribute = .left
    var secondAttribute: NSLayoutConstraint.Attribute = .notAnAttribute
    var constant: CGFloat = 0
    var identifier: String?
    var relation: NSLayoutConstraint.Relation = .equal
}

/// 自定义操作符 别名类型
precedencegroup ConstOp {
    associativity: left
    higherThan: AssignmentPrecedence
}

/* 警告
Operator should no longer be declared with body;use a precedence group instead
infix operator >>>- { associativity left precedence 150 }
*/
infix operator >>>- : ConstOp

@discardableResult
func >>>- <T: UIView> (left: T, block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    
    let constraint = NSLayoutConstraint(item: left,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: nil,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: (T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.0,
                                        attribute: info.attribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: (T, T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.2,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

// MARK: - UIView -
extension UIView {
    
    func addScaleToFillConstratinsOnView(_ view: UIView) {
        [NSLayoutConstraint.Attribute.left, .right, .top, .bottom].forEach { attribute in
            (self, view) >>>- {
                $0.attribute = attribute
                return
            }
        }
    }
    
    /// func getConstraint move to Ext_UIView.swift
    
}