//
//  WeakObjectContainer.swift
//  MethodSwizzling
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2020 Rockgarden. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

/// 弱对象容器
class WeakObjectContainer: NSObject {
    
    weak var object: AnyObject?
    let wrapper = WeakObjectContainer()
    
    /// Call the objc_setAssociatedObject func in swift
    ///
    /// - Parameters:
    ///   - container: The source object for the association.
    ///   - key: The key for the association.
    ///   - value: The value to associate with the key key for object. Pass nil to clear an existing association.
    func sw_objc_setAssociatedWeakObject(container: AnyObject, _ key: UnsafeRawPointer, _ value: AnyObject) {
        self.object = value
        objc_setAssociatedObject(container, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// Call the objc_getAssociatedObject func
    /// - Parameters:
    ///   - container: The source object for the association.
    ///   - key: The key for the association.
    func sw_objc_getAssociatedWeakObject(container: AnyObject, _ key: UnsafeRawPointer ) -> AnyObject {
        self.object = objc_getAssociatedObject(container, key) as AnyObject?
        return object!
    }
    
}
