//
//  FileUtility.swift
//  SimpleLib
//
//  Created by wangkan on 14-8-8.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import UIKit

/// 实现文件存储的类
class FileHelper: NSObject {
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    class func cachePath(_ fileName:String)->String
    {
        let arr =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path = arr[0]
        return "\(path)/\(fileName)"
    }
    
    class func imageCacheToPath(_ path:String,image:Data)->Bool
    {
        return ((try? image.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil)
    }
    
    class func imageDataFromPath(_ path:String)->AnyObject
    {
        let exist = Foundation.FileManager.default.fileExists(atPath: path)
        if exist
        {
            return  UIImage(contentsOfFile: path)!
        }
        
        return NSNull()
    }
    
}
