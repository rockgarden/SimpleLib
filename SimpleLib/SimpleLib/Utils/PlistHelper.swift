//
//  PlistHelper.swift
//
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
public func getDictionaryFromInfoPlist(keyName: String) -> AnyObject {
    let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")
    let dictionary = NSDictionary(contentsOfFile: plistPath!)!
    return dictionary.object(forKey: keyName)! as AnyObject
}

/**
 *  获取AppDefault.plist文件的数据
 *
 *  @param string 需要获取的字典目录名
 *
 *  @return 返回所查找的目录名字典
 */
public func getDictionaryFromAppDefaultPlist(_ keyName: String) -> Any {
    let plistPath = Bundle.main.path(forResource: "AppDefault",ofType: "plist")
    let dictionary = NSDictionary(contentsOfFile: plistPath!)!
    return dictionary.object(forKey: keyName)! as Any
}

public func getNSArrayFromPlist(_ plistName: String) -> NSArray {
    let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist")
    return NSArray(contentsOfFile: plistPath!)!
}

public func getArrayFromPlist(_ plistName: String) -> Array<Any> {
    let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist")
    return Array(arrayLiteral:plistPath!)
}


