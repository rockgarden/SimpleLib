//
//  ExtKIT
//  Ext_UIViewController.swift
//  基于运行时中关联对象(associated objects)和方法交叉(method swizzling)实现
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

private var didKDVCInitialized = false
private var interactiveNavigationBarHiddenAssociationKey: UInt8 = 0

@IBDesignable
extension UIViewController {

	/**
	 *  向工程里所有的 view controllers 中添加一个 descriptiveName 属性
	 *  在私有嵌套 struct 中使用 static var 这样生成的关联对象键不会污染整个命名空间
	 */
	private struct descriptiveAssociatedKeys {
		static var DescriptiveName = "rockgarden power"
	}

	var descriptiveName: String? {
		get {
			return objc_getAssociatedObject(self, &descriptiveAssociatedKeys.DescriptiveName) as? String
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&descriptiveAssociatedKeys.DescriptiveName,
					newValue as NSString?,
						.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}

	@IBInspectable
	public var interactiveNavigationBarHidden: Bool {
		get {
			let associateValue = objc_getAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey) ?? false
			return associateValue as! Bool
		}
		set {
			objc_setAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

    /// initialize 类方法不能在swift中调用
    open class func initializeOC() { // 也可用 override public static func initialize()

        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }

		struct Static {
            static var _token: Int?
		}

        objc_sync_enter(self)
        if Static._token == nil {
            Static._token = 0
            if !didKDVCInitialized {
                SwizzleMethod(cls: self, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.interactiveViewWillAppear(_:)))
                didKDVCInitialized = true
            }
        }

        objc_sync_exit(self)
	}

	@objc func interactiveViewWillAppear(_ animated: Bool) {
		interactiveViewWillAppear(animated)
		if let name = self.descriptiveName {
			debugPrint("viewWillAppear: \(name)")
		} else {
			debugPrint("viewWillAppear: \(self)")
		}
		debugPrint("ViewWillAppear setNavigationBarHidden: \(interactiveNavigationBarHidden)")
		navigationController?.setNavigationBarHidden(interactiveNavigationBarHidden, animated: animated)
	}

	func km_containerViewBackgroundColor() -> UIColor {
		return UIColor.white
	}
    
    /// 检查UIViewController有否释放
    ///
    /// - Parameter delay:
    public func checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
        let rvc = rootParentViewController

        if isMovingFromParentViewController || rvc.isBeingDismissed {
            let disappearanceSource: String = isMovingFromParentViewController ? "removed from its                     parent" : "dismissed"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                assert(self == nil, "\(type(of: self)) not deallocated after being \(disappearanceSource)")
            })
        }
    }
    
    private var rootParentViewController: UIViewController {
        var root = self
        
        while let parent = root.parent {
            root = parent
        }
        
        return root
    }

}

// MARK: - protocol UIViewLoading
protocol VCfromNib { }
extension UIViewController: VCfromNib { }
extension VCfromNib where Self: UIViewController {

    /// VC loadFromNib from main bundle
    ///
    /// - Returns: note that this method returns an instance of type `Self`, rather than UIViewController
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split { $0 == "." }.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
