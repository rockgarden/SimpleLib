//
//  Ext_Int.swift
//  SimpleLib
//
//  Created by 王侃 on 2020/2/20.
//  Copyright © 2020 rockgarden. All rights reserved.
//

import Foundation

extension Int {
    
    private static func random() -> Int {
        return Int(arc4random())
    }
    
    public static func random(min: Int, max: Int) -> Int {
        return Int.random() * (max - min) + min
    }
}
