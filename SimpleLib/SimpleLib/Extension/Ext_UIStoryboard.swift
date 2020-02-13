//
//  Ext_UIStoryboard.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/26.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    /// EZSE: Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    public static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    /// EZSE: Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    public func instantiateVC<T>(identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
}

//FIXME: 无法通过动态包调用
extension UIStoryboard {

	enum Storyboard: String {
		case Main
	}

	convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
		self.init(name: storyboard.rawValue, bundle: bundle)
	}

	convenience init(storyboardName: String, bundle: Bundle? = nil) {
		self.init(name: storyboardName, bundle: bundle)
	}

	class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
	}

	func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
		guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
			fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
		}
		return viewController
	}

	func getViewControllerFromStoryboard(viewController: String, storyboard: String) -> UIViewController {
		let sBoard = UIStoryboard(name: storyboard, bundle: nil)
		let vController: UIViewController = sBoard.instantiateViewController(withIdentifier: viewController)
		return vController
	}
}

extension UIViewController: StoryboardIdentifiable { }

/**
 *  identifiable
 */
protocol StoryboardIdentifiable {
	static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
	static var storyboardIdentifier: String {
		return String(describing: self)
	}
}

