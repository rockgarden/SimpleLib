//
//  ExtKIT
//  Ext_UIColor.swift
//  MemoryInMap
//
//  Created by wangkan on 16/6/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

extension UIColor {
    /// EZSE: init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public static func RGB(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return RGBA(r, g: g, b: b, a: 1.0)
    }
    
    public static func RGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// EZSE: init method with hex string and alpha(default: 1)
    public convenience init?(_ hexStr: String, alpha: CGFloat = 1.0) {
        var formatted = hexStr.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha) }
        else {
            return nil
        }
    }

    class func hex (_ hexStr : NSString, alpha : CGFloat) -> UIColor {
        let realHexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: realHexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white
        }
    }
    
    public static func fRGB(_ rgbValue: UInt32) -> UIColor {
        return UIColor(red: (CGFloat)((rgbValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((rgbValue & 0xFF00) >> 8) / 255.0, blue: (CGFloat)(rgbValue & 0xFF) / 255.0, alpha: 1.0)
    }
    
    /// EZSE: init method from Gray value and alpha(default:1)
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray / 255, green: gray / 255, blue: gray / 255, alpha: alpha)
    }
    
    /// EZSE: Red component of UIColor (get-only)
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    /// EZSE: Green component of UIColor (get-only)
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    /// EZSE: blue component of UIColor (get-only)
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    /// EZSE: Alpha of UIColor (get-only)
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    /// EZSE: Returns random UIColor with random alpha(default: false)
    public static func randomColor(_ randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
}

private extension CGFloat {
    /// SwiftRandom extension
    static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}
