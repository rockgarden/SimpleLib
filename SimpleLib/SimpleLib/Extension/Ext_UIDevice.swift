//
//  Ext_UIDevice.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return "iPad Pro"
        case "AppleTV5,3": return "Apple TV"
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }
    
}

import Foundation
import UIKit

// MARK: - Private variables-

/// Used to store BFAPNSIdentifier in defaults.
private let BFAPNSIdentifierDefaultsKey = "BFAPNSIdentifier"
/// Used to store BFDeviceIdentifier in defaults.
internal let BFDeviceIdentifierDefaultsKey = "BFDeviceIdentifier"
/// Used to store the BFUniqueIdentifier in defaults
private let BFUniqueIdentifierDefaultsKey = "BFUniqueIdentifier"
private let BFUserUniqueIdentifierDefaultsKey = "BFUserUniqueIdentifier"

// MARK: - Global functions -

/**
 Get the iOS version string
 
 - returns: Get the iOS version string
 */
public func osVersion() -> String {
    return UIDevice.current.systemVersion
}

/// Compare OS versions.
///
/// - Parameter version: Version, like "9.0".
/// - Returns: Returns true if equal, otherwise false.
public func osVersionEqual(_ version: String) -> Bool {
    UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
}

/// Compare OS versions.
///
/// - Parameter version: Version, like "9.0".
/// - Returns: Returns true if greater, otherwise false.
public func osVersionGreaterThan(_ version: String) -> Bool {
    UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
}

/// Compare OS versions.
///
/// - Parameter version: Version, like "9.0".
/// - Returns: Returns true if greater or equal, otherwise false.
public func osVersionGreaterThanOrEqual(_ version: String) -> Bool {
    UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
}

/// Compare OS versions.
///
/// - Parameter version: Version, like "9.0".
/// - Returns: Returns true if less, otherwise false.
public func osVersionLessThan(_ version: String) -> Bool {
    UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
}

/// Compare OS versions.
///
/// - Parameter version: Version, like "9.0".
/// - Returns: Returns true if less or equal, otherwise false.
public func osVersionLessThanOrEqual(_ version: String) -> Bool {
    UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
}

/**
 Returns if the iOS version is greater or equal to choosed one
 
 - returns: Returns if the iOS version is greater or equal to choosed one
 */
public func IS_IOS_5_OR_LATER() -> Bool {
    return UIDevice.current.systemVersion.floatValue >= 5.0
}

/**
 Returns if the iOS version is greater or equal to choosed one
 
 - returns: Returns if the iOS version is greater or equal to choosed one
 */
public func IS_IOS_6_OR_LATER() -> Bool {
    return UIDevice.current.systemVersion.floatValue >= 6.0
}

/**
 Returns if the iOS version is greater or equal to choosed one
 
 - returns: Returns if the iOS version is greater or equal to choosed one
 */
public func IS_IOS_7_OR_LATER() -> Bool {
    return UIDevice.current.systemVersion.floatValue >= 7.0
}

/**
 Returns if the iOS version is greater or equal to choosed one
 
 - returns: Returns if the iOS version is greater or equal to choosed one
 */
public func IS_IOS_8_OR_LATER() -> Bool {
    return UIDevice.current.systemVersion.floatValue >= 8.0
}

/**
 Returns if the iOS version is greater or equal to choosed one
 
 - returns: Returns if the iOS version is greater or equal to choosed one
 */
public func IS_IOS_9_OR_LATER() -> Bool {
    return UIDevice.current.systemVersion.floatValue >= 9.0
}

/// This extesion adds some useful functions to UIDevice
public extension UIDevice {
    
    // MARK: - Variables-
    
    /// Get OS version string.
    static var osVersion: String {
        UIDevice.current.systemVersion
    }
    
    /// Returns OS version without subversions.
    static var osMajorVersion: Int {
        let subVersion = UIDevice.current.systemVersion.substringToCharacter(character: ".")
        guard let intSubVersion = Int(subVersion!) else {
            return 0
        }
        return intSubVersion
    }
    
    /// Returns device platform string.
    ///
    /// Example: "iPhone7,2".
    ///
    /// - Returns: Returns the device platform string.
    static var hardwareModel: String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var nameCopy = name
        var size: Int = 2
        sysctl(&nameCopy, 2, nil, &size, &name, 0)
        var hwMachine = [CChar](repeating: 0, count: Int(size))
        sysctl(&nameCopy, 2, &hwMachine, &size, &name, 0)
        
        let hardware = String(cString: hwMachine)
        return hardware
    }
    
    // swiftlint:disable switch_case_on_newline
    
    /// Returns the user-friendly device platform string.
    /// More info [here](https://www.theiphonewiki.com/wiki/Models).
    ///
    /// Example: "iPad Air (Cellular)".
    ///
    /// - Returns: Returns the user-friendly device platform string.
    static var detailedModel: String {
        let platform: String = hardwareModel
        
        switch platform {
        // iPhone 2G
        case "iPhone1,1":       return "iPhone 2G"
        // iPhone 3G
        case "iPhone1,2":       return "iPhone 3G"
        // iPhone 3GS
        case "iPhone2,1":       return "iPhone 3GS"
        // iPhone 4
        case "iPhone3,1":       return "iPhone 4"
        case "iPhone3,2":       return "iPhone 4"
        case "iPhone3,3":       return "iPhone 4"
        // iPhone 4S
        case "iPhone4,1":       return "iPhone 4S"
        // iPhone 5
        case "iPhone5,1":       return "iPhone 5"
        case "iPhone5,2":       return "iPhone 5"
        // iPhone 5c
        case "iPhone5,3":       return "iPhone 5c"
        case "iPhone5,4":       return "iPhone 5c"
        // iPhone 5s
        case "iPhone6,1":       return "iPhone 5s"
        case "iPhone6,2":       return "iPhone 5s"
        // iPhone 6 / 6 Plus
        case "iPhone7,1":       return "iPhone 6 Plus"
        case "iPhone7,2":       return "iPhone 6"
        // iPhone 6s / 6s Plus
        case "iPhone8,1":       return "iPhone 6s"
        case "iPhone8,2":       return "iPhone 6s Plus"
        // iPhone SE
        case "iPhone8,4":       return "iPhone SE"
        // iPhone 7 / 7 Plus
        case "iPhone9,1":       return "iPhone 7"
        case "iPhone9,2":       return "iPhone 7 Plus"
        case "iPhone9,3":       return "iPhone 7"
        case "iPhone9,4":       return "iPhone 7 Plus"
        // iPhone 8 / 8 Plus
        case "iPhone10,1":      return "iPhone 8"
        case "iPhone10,2":      return "iPhone 8 Plus"
        case "iPhone10,4":      return "iPhone 8"
        case "iPhone10,5":      return "iPhone 8 Plus"
        // iPhone X
        case "iPhone10,3":      return "iPhone X"
        case "iPhone10,6":      return "iPhone X"
        // iPhone XS / iPhone XS Max
        case "iPhone11,2":      return "iPhone XS"
        case "iPhone11,4":      return "iPhone XS Max"
        case "iPhone11,6":      return "iPhone XS Max"
        // iPhone XR
        case "iPhone11,8":      return "iPhone XR"
        // iPhone 11
        case "iPhone12,1":      return "iPhone 11"
        // iPhone 11 Pro Max
        case "iPhone12,3":      return "iPhone 11 Pro"
        // iPhone 11 Pro
        case "iPhone12,5":      return "iPhone 11 Pro Max"
        // iPod touch
        case "iPod1,1":         return "iPod touch (1st generation)"
        case "iPod2,1":         return "iPod touch (2nd generation)"
        case "iPod3,1":         return "iPod touch (3rd generation)"
        case "iPod4,1":         return "iPod touch (4th generation)"
        case "iPod5,1":         return "iPod touch (5th generation)"
        case "iPod7,1":         return "iPod touch (6th generation)"
        case "iPod9,1":         return "iPod touch (7th generation)"
        // iPad / iPad Air
        case "iPad1,1":         return "iPad"
        case "iPad2,1":         return "iPad 2"
        case "iPad2,2":         return "iPad 2"
        case "iPad2,3":         return "iPad 2"
        case "iPad2,4":         return "iPad 2"
        case "iPad3,1":         return "iPad 3"
        case "iPad3,2":         return "iPad 3"
        case "iPad3,3":         return "iPad 3"
        case "iPad3,4":         return "iPad 4"
        case "iPad3,5":         return "iPad 4"
        case "iPad3,6":         return "iPad 4"
        case "iPad4,1":         return "iPad Air"
        case "iPad4,2":         return "iPad Air"
        case "iPad4,3":         return "iPad Air"
        case "iPad5,3":         return "iPad Air 2"
        case "iPad5,4":         return "iPad Air 2"
        case "iPad6,11":        return "iPad Air 2"
        case "iPad6,12":        return "iPad Air 2"
        case "iPad11,3":        return "iPad Air (3rd generation)"
        case "iPad11,4":        return "iPad Air (3rd generation)"
        // iPad mini
        case "iPad2,5":         return "iPad mini"
        case "iPad2,6":         return "iPad mini"
        case "iPad2,7":         return "iPad mini"
        case "iPad4,4":         return "iPad mini 2"
        case "iPad4,5":         return "iPad mini 2"
        case "iPad4,6":         return "iPad mini 2"
        case "iPad4,7":         return "iPad mini 3"
        case "iPad4,8":         return "iPad mini 3"
        case "iPad4,9":         return "iPad mini 3"
        case "iPad5,1":         return "iPad mini 4"
        case "iPad5,2":         return "iPad mini 4"
        case "iPad11,1":        return "iPad mini (5th generation)"
        case "iPad11,2":        return "iPad mini (5th generation)"
        // iPad Pro 9.7
        case "iPad6,3":         return "iPad Pro (9.7-inch)"
        case "iPad6,4":         return "iPad Pro (9.7-inch)"
        // iPad Pro 10.5
        case "iPad7,3":         return "iPad Pro (10.5-inch)"
        case "iPad7,4":         return "iPad Pro (10.5-inch)"
        // iPad Pro 11
        case "iPad8,1":         return "iPad Pro (11-inch)"
        case "iPad8,2":         return "iPad Pro (11-inch)"
        case "iPad8,3":         return "iPad Pro (11-inch)"
        case "iPad8,4":         return "iPad Pro (11-inch)"
        // iPad Pro 12.9
        case "iPad6,7":         return "iPad Pro (12.9-inch)"
        case "iPad6,8":         return "iPad Pro (12.9-inch)"
        case "iPad7,1":         return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad7,2":         return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad8,5":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,6":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,7":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,8":         return "iPad Pro (12.9-inch, 3rd generation)"
        // Apple TV
        case "AppleTV2,1":      return "Apple TV (2nd generation)"
        case "AppleTV3,1":      return "Apple TV (3rd generation)"
        case "AppleTV3,2":      return "Apple TV (3rd generation)"
        case "AppleTV5,3":      return "Apple TV (4th generation)"
        case "AppleTV6,2":      return "Apple TV 4K"
        // Simulator
        case "i386", "x86_64":  return "Simulator"
        default:
            return "Unknown"
        }
    }
    
    // swiftlint:enable switch_case_on_newline
    
    /// Returns current device CPU frequency.
    static var cpuFrequency: Int {
        getSysInfo(HW_CPU_FREQ)
    }
    
    /// Returns current device BUS frequency.
    static var busFrequency: Int {
        getSysInfo(HW_TB_FREQ)
    }
    
    /// Returns device RAM size.
    static var ramSize: Int {
        getSysInfo(HW_MEMSIZE)
    }
    
    /// Returns device CPUs number.
    static var cpusNumber: Int {
        getSysInfo(HW_NCPU)
    }
    
    /// Returns device total memory.
    static var totalMemory: Int {
        getSysInfo(HW_PHYSMEM)
    }
    
    /// Returns current device non-kernel memory.
    static var userMemory: Int {
        getSysInfo(HW_USERMEM)
    }
    
    /// Retruns if current device is running in low power mode.
    @available(iOS 9.0, *)
    static var isLowPowerModeEnabled: Bool {
        ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    /// Low power mode observer.
    private static var lowPowerModeObserver = false
    
    // MARK: - Class functions -
    
    /// Executes a block everytime low power mode is enabled o disabled.
    ///
    /// - Parameter block: Block to be executed.
    @objc
    @available(iOS 9.0, *)
    static func lowPowerModeChanged(_ block: @escaping (_ isLowPowerModeEnabled: Bool) -> Void) {
        if !lowPowerModeObserver {
            NotificationCenter.default.addObserver(self, selector: #selector(lowPowerModeChanged(_:)), name: .NSProcessInfoPowerStateDidChange, object: nil)
            lowPowerModeObserver = true
        }
        
        block(UIDevice.isLowPowerModeEnabled)
    }
    
    /// Check if current device is an iPhone.
    ///substringToIndex(4)
    /// - Returns: Returns true if it is an iPhone, otherwise false.
    static func isPhone() -> Bool {
        hardwareModel.substringToIndex(6) == "iPhone"
    }
    
    /// Check if current device is an iPad.
    ///
    /// - Returns: Returns true if it is an iPad, otherwise false.
    static func isPad() -> Bool {
        hardwareModel.substringToIndex(4) == "iPad"
    }
    
    /// Check if current device is an iPod.
    ///
    /// - Returns: Returns true if it is an iPod, otherwise false.
    static func isPod() -> Bool {
        hardwareModel.substringToIndex(4) == "iPod"
    }
    
    /// Check if current device is an Apple TV.
    ///
    /// - Returns: Returns true if it is an Apple TV, otherwise false.
    static func isTV() -> Bool {
        hardwareModel.substringToIndex(7) == "AppleTV"
    }
    
    /// Check if current device is an Applw Watch.
    ///
    /// - Returns: Returns true if it is an Apple Watch, otherwise false.
    static func isWatch() -> Bool {
        hardwareModel.substringToIndex(5) == "Watch"
    }
    
    /// Check if current device is a Simulator.
    ///
    /// - Returns: Returns true if it is a Simulator, otherwise false.
    static func isSimulator() -> Bool {
        detailedModel == "Simulator"
    }
    
    /// Returns if current device is jailbroken.
    ///
    /// - Returns: Returns true if current device is jailbroken, otherwise false.
    static func isJailbroken() -> Bool {
        let canReadBinBash = FileManager.default.fileExists(atPath: "/bin/bash")
        if let cydiaURL = URL(string: "cydia://"), let canOpenCydia = (UIApplication.value(forKey: "sharedApplication") as? UIApplication)?.canOpenURL(cydiaURL) {
            return canOpenCydia || canReadBinBash
        } else {
            return canReadBinBash
        }
    }
    
    /// Returns system uptime.
    ///
    /// - Returns: eturns system uptime.
    static func uptime() -> TimeInterval {
        ProcessInfo.processInfo.systemUptime
    }
    
    /// Returns sysyem uptime as Date.
    ///
    /// - Returns: Returns sysyem uptime as Date.
    static func uptimeDate() -> Date {
        Date(timeIntervalSinceNow: -uptime())
    }
    
    /// Returns current device total disk space
    ///
    /// - Returns: Returns current device total disk space.
    static func totalDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
    }
    
    /// Returns current device free disk space.
    ///
    /// - Returns: Returns current device free disk space.
    static func freeDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemFreeSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
    }
    
    /// Used to the system info.
    ///
    /// - Parameter typeSpecifier: Type of system info.
    /// - Returns: Return sysyem info.
    fileprivate static func getSysInfo(_ typeSpecifier: Int32) -> Int {
        var name: [Int32] = [CTL_HW, typeSpecifier]
        var nameCopy = name
        var size: Int = 2
        sysctl(&nameCopy, 2, nil, &size, &name, 0)
        var results: Int = 0
        sysctl(&nameCopy, 2, &results, &size, &name, 0)
        
        return results
    }
    
    /**
     Check if the current device has a Retina display
     
     - returns: Returns true if it has a Retina display, false if not
     */
    @available(*, deprecated, message: "Use isRetina() in UIScreen class")
    static func isRetina() -> Bool {
        return UIScreen.isRetina()
    }
    
    /**
     Check if the current device has a Retina HD display
     
     - returns: Returns true if it has a Retina HD display, false if not
     */
    @available(*, deprecated, message: "Use isRetinaHD() in UIScreen class")
    static func isRetinaHD() -> Bool {
        return UIScreen.isRetinaHD()
    }
    
    /**
     Returns the iOS version without the subversion
     Example: 7
     
     - returns: Returns the iOS version
     */
    static func iOSVersion() -> Int {
        return Int(UIDevice.current.systemVersion.substringToCharacter(character: ".")!)!
    }
    
    /// When `save` is false, a new UUID will be created every time.
    /// When `save` is true, a new UUID will be created and saved in the user defatuls.
    /// It will be retrieved on next calls.
    ///
    /// - Parameters:
    ///   - save: If true the UUID will be saved, otherview not.
    ///   - force: If true a new UUID will be forced, even there is a saved one.
    /// - Returns: Returns the created (`save` = false`) or retrieved (`save` = true) UUID String.
    static func generateUniqueIdentifier(save: Bool = false, force: Bool = false) -> String {
        if save {
            let defaults = UserDefaults.standard
            
            guard !force else {
                let identifier = UUID().uuidString
                defaults.set(identifier, forKey: BFDeviceIdentifierDefaultsKey)
                defaults.synchronize()
                return identifier
            }
            
            guard let identifier = defaults.string(forKey: BFDeviceIdentifierDefaultsKey) else {
                let identifier = UUID().uuidString
                defaults.set(identifier, forKey: BFDeviceIdentifierDefaultsKey)
                defaults.synchronize()
                return identifier
            }
            
            return identifier
        }
        
        return UUID().uuidString
    }
    
    /// Save the unique identifier or update it if there is and it is changed.
    /// Is useful for push notification to know if the unique identifier has changed and needs to be sent to server.
    ///
    /// - Parameters:
    ///   - uniqueIdentifier: The unique identifier to save or update if needed. Must be Data or String type.
    ///   - completion:       The execution block that know if the unique identifier is valid and has to be updated.
    ///                               You have to handle the case if it is valid and the update is needed or not.
    ///
    ///   - isValid:          Returns if the APNS token is valid.
    ///   - needsUpdate:      Returns if the APNS token needsAnUpdate.
    ///   - oldUUID:          Returns the old UUID, if present. May be nil.
    ///   - newUUID:          Returns the new UUID.
    static func saveAPNSIdentifier(_ uniqueIdentifier: Any, completion: @escaping (_ isValid: Bool, _ needsUpdate: Bool, _ oldUUID: String?, _ newUUID: String) -> Void) {
        var newUUID: String = ""
        var oldUUID: String?
        var isValid = false, needsUpdate = false
        
        if uniqueIdentifier is Data, let data: Data = uniqueIdentifier as? Data, let newUUIDData = data.utf8() {
            isValid = newUUIDData.isUUIDForAPNS()
        } else if uniqueIdentifier is String, let string = uniqueIdentifier as? String {
            newUUID = string.readableUUID()
            isValid = newUUID.isUUIDForAPNS()
        }
        
        if isValid {
            let defaults = UserDefaults.standard
            
            oldUUID = defaults.string(forKey: BFAPNSIdentifierDefaultsKey)
            if oldUUID == nil || oldUUID != newUUID {
                defaults.set(newUUID, forKey: BFAPNSIdentifierDefaultsKey)
                defaults.synchronize()
                
                needsUpdate = true
            }
        }
        
        completion(isValid, needsUpdate, oldUUID, newUUID)
    }
    
    /**
     Save the unique identifier or update it if there is and it is changed.
     Is useful for push notification to know if the unique identifier has changed and needs to be send to server
     
     - parameter uniqueIdentifier: The unique identifier to save or update if needed. (Must be NSData or NSString)
     - parameter block:            The execution block that know if the unique identifier is valid and has to be updated. You have to handle the case if it is valid and the update is needed or not
     */
    static func updateUniqueIdentifier(uniqueIdentifier: NSObject, block: (_ isValid: Bool, _ hasToUpdateUniqueIdentifier: Bool, _ oldUUID: String?) -> ()) {
        var userUUID: String = ""
        var savedUUID: String? = nil
        var isValid = false, hasToUpdate = false
        
        if uniqueIdentifier is NSData {
            let data: NSData = uniqueIdentifier as! NSData
            userUUID = data.convertToUTF8String()
        } else if uniqueIdentifier is NSString {
            let string: NSString = uniqueIdentifier as! NSString
            userUUID = string.convertToAPNSUUID() as String
        }
        
        isValid = userUUID.isUUIDForAPNS()
        
        if isValid {
            let defaults: UserDefaults = UserDefaults.standard
            savedUUID = defaults.string(forKey: BFUserUniqueIdentifierDefaultsKey)
            if savedUUID == nil || savedUUID != userUUID {
                defaults.set(userUUID, forKey: BFUserUniqueIdentifierDefaultsKey)
                defaults.synchronize()
                
                hasToUpdate = true
            }
        }
        
        block(isValid, hasToUpdate, userUUID)
    }
}