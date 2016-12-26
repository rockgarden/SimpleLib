//
//  PlistUtil.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation

/**
 获取Info.plist文件的数据
 
 - parameter keyName: 需要获取的字典名
 
 - returns: 返回对应的值
 */
public func getDictionaryFromInfoPlist(_ keyName: String) -> AnyObject {
    let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")
    let dictionary = NSDictionary(contentsOfFile: plistPath!)!
    return dictionary.object(forKey: keyName)! as AnyObject
}


public func getArrayFromPlist(_ plistName: String) -> NSArray {
    let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist")
    return NSArray(contentsOfFile: plistPath!)!
}




