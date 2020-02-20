//
//  AppCommon.swift
//  SimpleLib
//
//  使用SimpleLib时必须引入的文件
//
//

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
public func BFLocalizedString(key: String, _ comment: String? = nil) -> String {
    return Bundle(for: AppCommon.self).localizedString(forKey: key, value: key, table: "BFKit")
}

/**
 NSLocalizedString without comment parameter
 
 - parameter key: The key of the localized string
 
 - returns: Returns a localized string
 */
public func NSLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

/// Get AppDelegate (To use it, cast to AppDelegate with "as! AppDelegate")
let APP_DELEGATE: UIApplicationDelegate? = UIApplication.shared.delegate

/// This class adds some useful functions for the App
public class AppCommon {
    // MARK: - Class functions -
    
    /**
     Executes a block only if in DEBUG mode
     
     - parameter block: The block to be executed
     */
    public static func debugBlock(block: () -> ()) {
        #if DEBUG
        block()
        #endif
    }
    
    /**
     Executes a block on first start of the App.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStart
     */
    public static func onFirstStart(block: (_ isFirstStart: Bool) -> ()) {
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
    public static func onFirstStartForCurrentVersion(block: (_ isFirstStartForCurrentVersion: Bool) -> ()) {
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
    public static func onFirstStartForVersion(version: String, block: (_ isFirstStartForVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForVersion != true {
            defaults.set(true, forKey: BFHasBeenOpened + "\(version)")
            defaults.synchronize()
        }
        
        block(!hasBeenOpenedForVersion)
    }
    
    /// Returns if is the first start of the App
    public static var isFirstStart: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: BFHasBeenOpened)
        if hasBeenOpened != true {
            return true
        } else {
            return false
        }
    }
    
    /// Returns if is the first start of the App for current version
    public static var isFirstStartForCurrentVersion: Bool {
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
    public static func isFirstStartForVersion(version: String) -> Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
    
    static private var indicator : UIActivityIndicatorView!
    
    public static func showTopWait(){
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        let rv = UIApplication.shared.keyWindow?.subviews.first
        window.backgroundColor = UIColor.clear
        indicator = UIActivityIndicatorView(frame: frame)
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
    }
    
    static func setFontWithStroke(_ control:UIView?, fontSize: CGFloat, fontName: String, fontColor: UIColor, strokeColor: UIColor = UIColor.black, strokeWidth: CGFloat = -2.0, alignment: NSTextAlignment = .center) {
        if control == nil { return }
        
        let textAtts = [NSAttributedString.Key.font.rawValue: UIFont(name: fontName, size: fontSize)!,
                        NSAttributedString.Key.foregroundColor: fontColor,
                        NSAttributedString.Key.strokeColor: strokeColor,
                        NSAttributedString.Key.strokeWidth: strokeWidth ] as! [NSAttributedString.Key : Any]
        
        switch control {
        case is UITextField:
            let tf = control as! UITextField
            tf.defaultTextAttributes = textAtts
            tf.textAlignment = alignment
            
        case is UILabel:
            let lbl = control as! UILabel
            lbl.attributedText = NSAttributedString(string: lbl.text!, attributes: textAtts)
            lbl.textAlignment = alignment
            
        default:
            print("Ooops, unhandled control type")
        }
    }
    
    static func listAvailableFonts() {
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for font in fontNames { print(font) }
        }
    }
    
    //MARK: - Images
    ///NOTE:getNSURLUserFilePathForFileName has been updated to Swift 3 but is untested.
    ///     In particular, what is not known is whether there should be a slash btw dirPath and fileName in path string variable
    static func getNSURLUserFilePathForFileName(_ fileName: String) -> URL? {
        //BUILD file path and READY session
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = "\(dirPath)\(fileName)"
        
        return URL(fileURLWithPath: path)
    }
    
    
    static func getImageFromMainBundle(_ imageNameAndExtension: String) -> UIImage {
        if let image = UIImage(named: imageNameAndExtension, in: Bundle.main, compatibleWith: nil) {
            return image
        }
        else {
            //RETURN empty image if no image found
            return UIImage()
        }
    }
    
    static func writeImageToCameraRoll(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
