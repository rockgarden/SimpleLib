//
//  Ext_DispatchQueue.swift
//  SimpleLib
//
//  Created by wangkan on 2017/2/21.
//  Copyright © 2017年 rockgarden. All rights reserved.
//  解决dispatch_once方法在swift 3.0中不起作用: 'dispatch_once' is unavailable in Swift: Use lazily initialized globals instead
//  

extension DispatchQueue {

    private static var _onceTracker = [String]()
    public static var _onceToken: String {
        get {
            return NSUUID().uuidString
        }
    }

    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String = _onceToken, block:()->Void) { //block:@noescape(Void)->Void
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }

}


public struct DispatchOnce {
    private var lock: OSSpinLock = OS_SPINLOCK_INIT
    private var isInitialized = false
    public /* mutating */ mutating func perform(block: () -> Void) {
        OSSpinLockLock(&lock)
        if !isInitialized {
            block()
            isInitialized = true
        }
        OSSpinLockUnlock(&lock)
    }
}

public final class DispatchOnceC {
    private var lock: OSSpinLock = OS_SPINLOCK_INIT
    private var isInitialized = false
    public /* mutating */ func perform(block: () -> Void) {
        OSSpinLockLock(&lock)
        if !isInitialized {
            block()
            isInitialized = true
        }
        OSSpinLockUnlock(&lock)
    }
}

//class MyViewController: UIViewController {
//
//    private let /* var */ setUpOnce = DispatchOnce()
//
//    override func viewWillAppear() {
//        super.viewWillAppear()
//        setUpOnce.perform {
//            // Do some work here
//            // ...
//        }
//    }
//    
//}


/* Objc Type
 .h:
 typedef dispatch_once_t mxcl_dispatch_once_t;
 void mxcl_dispatch_once(mxcl_dispatch_once_t *predicate, dispatch_block_t block);
 .m:
 void mxcl_dispatch_once(mxcl_dispatch_once_t *predicate, dispatch_block_t block) {
 dispatch_once(predicate, block);
 }
 */


