//
//  MethodSwizzling.swift
//  MethodSwizzling
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2020 Rockgarden. All rights reserved.
//
//  参考 https://github.com/steipete/Aspects

import Foundation
import ObjectiveC.runtime

/// 实现类方法拦截并动态替换
public class MethodSwizzling {
    
     public func SwizzlingMethod(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
		let originalMethod = class_getInstanceMethod(cls, originalSelector)
		let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        guard (swizzledMethod != nil && originalMethod != nil) else {
            let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            if didAddMethod {
                class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            return
        }
	}
    
}
