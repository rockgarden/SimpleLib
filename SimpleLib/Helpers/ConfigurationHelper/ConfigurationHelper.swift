//
//  ConfigurationHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import Foundation
//closure 被@noescape修饰, 则声明 closure 的生命周期不能超过 hostFunc, 并且, closure不能被hostFunc中的其他闭包捕获(也就是强持有).
@warn_unused_result
public func Init<Type>(value: Type, @noescape block: (object: Type) -> Void) -> Type
{
	block(object: value)
	return value
}
