//
//  WeakObjectContainer.swift
//  NavigationBarTransition
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

class WeakObjectContainer: NSObject {
    weak var object: AnyObject?
    let wrapper = WeakObjectContainer()

    func km_objc_setAssociatedWeakObject(container: AnyObject, _ key: UnsafeRawPointer, _ value: AnyObject) {
        self.object = value
        objc_setAssociatedObject(container, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func km_objc_getAssociatedWeakObject(container: AnyObject, _ key: UnsafeRawPointer ) -> AnyObject {
        self.object = objc_getAssociatedObject(container, key) as AnyObject?
        return object!
    }
}
