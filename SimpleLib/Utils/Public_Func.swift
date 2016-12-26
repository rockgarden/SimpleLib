//
//  PublicFunc.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/28.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

//TODO: 实现传入self
public func getBarHeight(_ viewController: AnyObject) -> CGFloat {
	//let heightNavBar = self.navigationController!.navigationBar.frame.height ?? 0
	let heightStatusBar = UIApplication.shared.statusBarFrame.height ?? 0
	//return heightNavBar + heightStatusBar
    return heightStatusBar
}
