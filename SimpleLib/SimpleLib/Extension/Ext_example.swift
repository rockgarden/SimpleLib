//
//  Ext_example.swift
//  SimpleLib
//
//  Created by wangkan on 2017/2/28.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

// Auto是一个接受一个泛型类型的结构体
public struct Auto<Base> {
    // 定义该泛型类型属性
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

// 写一个协议  定义一个只读的类型
public protocol UIViewConstratinsHelper {
    associatedtype ConstratinsHelper
    var ch: ConstratinsHelper { get }
}

public extension UIViewConstratinsHelper {
    // 指定泛型类型为自身，自身是协议 谁实现了此协议就是谁了
    var ch: Auto<Self> {
        get { return Auto(self) } // 初始化 传入自己
        set { }
    }
}

// 扩展 UIView 实现  UIViewCompatible 协议，就拥有了ch属性 ch又是Auto类型  Auto是用泛型实例化的  这个泛型就是UIView了
extension UIView: UIViewConstratinsHelper { }


// 写一个Auto的扩展 指定泛型类型是UIView 或者其子类
public extension Auto where Base: UIView {
    var height: CGFloat{
        set(v){
            self.base.frame.size.height = v
        }
        get{
            return self.base.frame.size.height
        }
    }
}

// UIView.ch.height
