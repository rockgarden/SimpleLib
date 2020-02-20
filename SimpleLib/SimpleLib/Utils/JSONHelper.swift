//
//  JSONHelper.swift
//  SimpleLib
//
//  Created by 王侃 on 2020/2/17.
//  Copyright © 2020 rockgarden. All rights reserved.
//

import Foundation

open class JSONUtil {
    
    class func parseFromJsonString(_ str:String) -> Any? {
        var err: NSError?
        let enc = String.Encoding.utf8
        var obj: Any?
        do {
            obj = try JSONSerialization.jsonObject(
                with: str.data(using: enc)!, options:[])
        } catch let error as NSError {
            err = error
            obj = nil
        }
        if (err != nil) { NSLog("error: %@", err!) }
        return obj
    }
    
    class func stringFromObject(_ obj:Any) -> String? {
        var err: NSError?
        let data: Data?
        do {
            data = try JSONSerialization.data(
                withJSONObject: obj, options:[])
        } catch let error as NSError {
            err = error
            data = nil
        }
        if (err != nil) {
            NSLog("error: %@", err!)
            return nil
        }
        return NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as String?
    }
}
