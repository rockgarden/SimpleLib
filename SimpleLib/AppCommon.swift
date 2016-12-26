//
//  AppCommon.swift
//  SimpleLib
//
//  使用SimpleLib时必须引入的文件
//
//  BFKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2016 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit

// MARK: - Variables -

/// Used to store the BFHasBeenOpened in defaults
private let BFHasBeenOpened = "BFHasBeenOpened"
/// Used to store the BFHasBeenOpenedForCurrentVersion in defaults
private let BFHasBeenOpenedForCurrentVersion = "\(BFHasBeenOpened)\(APP_VERSION)"

/// Get App name
public let APP_NAME: String = Bundle(for: AppCommon.self).infoDictionary!["CFBundleDisplayName"] as! String

/// Get App build
public let APP_BUILD: String = Bundle(for: AppCommon.self).infoDictionary!["CFBundleVersion"] as! String

/// Get App version
public let APP_VERSION: String = Bundle(for: AppCommon.self).infoDictionary!["CFBundleShortVersionString"] as! String
public var appVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String!

// MARK: - Global functions -

/**
 Use BFLocalizedString to use the string translated by BFKit
 
 - parameter key:     The key string
 - parameter comment: An optional comment
 
 - returns: Returns the localized string
 */
public func BFLocalizedString(_ key: String, _ comment: String? = nil) -> String {
    return Bundle(for: AppCommon.self).localizedString(forKey: key, value: key, table: "BFKit")
}

/**
 NSLocalizedString without comment parameter
 
 - parameter key: The key of the localized string
 
 - returns: Returns a localized string
 */
public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

/// Get AppDelegate (To use it, cast to AppDelegate with "as! AppDelegate")
let APP_DELEGATE: UIApplicationDelegate? = UIApplication.shared.delegate

/// This class adds some useful functions for the App
open class AppCommon {
    // MARK: - Class functions -
    
    /**
     Executes a block only if in DEBUG mode
     
     - parameter block: The block to be executed
     */
    open static func debugBlock(_ block: () -> ()) {
        #if DEBUG
            block()
        #endif
    }
    
    /**
     Executes a block on first start of the App.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStart
     */
    open static func onFirstStart(_ block: (_ isFirstStart: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: BFHasBeenOpened)
        if hasBeenOpened != true {
            defaults.set(true, forKey: BFHasBeenOpened)
            defaults.synchronize()
        }
        
        block(!hasBeenOpened)
    }
    
    /**
     Executes a block on first start of the App for current version.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStartForCurrentVersion
     */
    open static func onFirstStartForCurrentVersion(_ block: (_ isFirstStartForCurrentVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            defaults.set(true, forKey: BFHasBeenOpenedForCurrentVersion)
            defaults.synchronize()
        }
        
        block(!hasBeenOpenedForCurrentVersion)
    }
    
    /**
     Executes a block on first start of the App for current given version.
     Remember to execute UI instuctions on main thread
     
     - parameter version: Version to be checked
     - parameter block:   The block to execute, returns isFirstStartForVersion
     */
    open static func onFirstStartForVersion(_ version: String, block: (_ isFirstStartForVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForVersion != true {
            defaults.set(true, forKey: BFHasBeenOpened + "\(version)")
            defaults.synchronize()
        }
        
        block(!hasBeenOpenedForVersion)
    }
    
    /// Returns if is the first start of the App
    open static var isFirstStart: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: BFHasBeenOpened)
        if hasBeenOpened != true {
            return true
        } else {
            return false
        }
    }
    
    /// Returns if is the first start of the App for current version
    open static var isFirstStartForCurrentVersion: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
    
    /**
     Returns if is the first start of the App for the given version
     
     - parameter version: Version to be checked
     
     - returns: Returns if is the first start of the App for the given version
     */
    open static func isFirstStartForVersion(_ version: String) -> Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
}

