//
//  Ext_UIScreen.swift
//
//  Created by wangkan on 16/7/28.
//

import Foundation
import UIKit

/// This extesion adds some useful functions to UIScreen
public extension UIScreen {
    
    // MARK: - Variables
    
    /// Get the screen width.
    static var screenWidth: CGFloat {
        UIScreen.fixedScreenSize().width
    }
    
    /// Get the screen height.
    static var screenHeight: CGFloat {
        UIScreen.fixedScreenSize().height
    }
    
    /// Get the maximum screen length.
    static var maxScreenLength: CGFloat {
        max(screenWidth, screenHeight)
    }
    /// Get the minimum screen length.
    static var minScreenLength: CGFloat {
        min(screenWidth, screenHeight)
    }
    
    // MARK: - Class functions -
    
    /// Check if current device has a Retina display.
    ///
    /// - Returns: Returns true if it has a Retina display, otherwise false.
    static func isRetina() -> Bool {
        UIScreen.main.responds(to: #selector(UIScreen.displayLink(withTarget:selector:))) && UIScreen.main.scale == 2.0
    }
    
    /// Check if current device has a Retina HD display.
    ///
    /// - Returns: Returns true if it has a Retina HD display, otherwise false.
    static func isRetinaHD() -> Bool {
        UIScreen.main.responds(to: #selector(UIScreen.displayLink(withTarget:selector:))) && UIScreen.main.scale == 3.0
    }
    
    /// Returns fixed screen size, based on device orientation.
    ///
    /// - Returns: Returns a GCSize with the fixed screen size.
    static func fixedScreenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        
        if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 && UIApplication.shared.statusBarOrientation.isLandscape {
            return CGSize(width: screenSize.height, height: screenSize.width)
        }
        
        return screenSize
    }
    
    /// 0.0 to 1.0, where 1.0 is maximum brightness
    static var brightness: Float {
        get {
            return Float(UIScreen.brightness)
        }
        set(newValue) {
            UIScreen.brightness = newValue
        }
    }
}

