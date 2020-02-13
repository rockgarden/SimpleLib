//
//  ConfigurationHelper.swift
//  TestCollectionView
//
//  Created by Alex K. on 05/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import Foundation
//closure 被@noescape修饰, 则声明 closure 的生命周期不能超过 hostFunc, 并且, closure不能被hostFunc中的其他闭包捕获(也就是强持有).

public func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type
{
	block(value)
	return value
}
