//
//  Ext_DispatchTime.swift
//  SimpleLib
//
//  Created by wangkan on 2016/12/12.
//  Copyright © 2016年 rockgarden. All rights reserved.

//  DispatchQueue.main.asyncAfter(deadline: 5)

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

