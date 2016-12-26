//
//  MemoryCache.swift
//  Cache
//
//  Created by Sam Soffes on 5/6/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit
#else
	import Foundation
#endif

public final class MemoryCache<T>: Cache {

	// MARK: - Properties

	fileprivate let cache = NSCache<AnyObject, AnyObject>()


	// MARK: - Initializers

	#if os(iOS) || os(tvOS)
		public init(countLimit: Int? = nil, automaticallyRemoveAllObjects: Bool = false) {
			cache.countLimit = countLimit ?? 0

			if automaticallyRemoveAllObjects {
				let notificationCenter = NotificationCenter.default
				notificationCenter.addObserver(cache, selector: #selector(NSCache<AnyObject, AnyObject>.removeAllObjects), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
				notificationCenter.addObserver(cache, selector: #selector(NSCache<AnyObject, AnyObject>.removeAllObjects), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
			}
		}

		deinit {
			NotificationCenter.default.removeObserver(cache)
		}
	#else
		public init(countLimit: Int? = nil) {
			cache.countLimit = countLimit ?? 0
		}
	#endif


	// MARK: - Cache

	public func set(key: String, value: T, completion: (() -> Void)? = nil) {
		cache.setObject(Box(value), forKey: key as AnyObject)
		completion?()
	}

	public func get(key: String, completion: ((T?) -> Void)) {
		let box = cache.object(forKey: key as AnyObject) as? Box<T>
		let value = box.flatMap({ $0.value })
		completion(value)
	}

	public func remove(key: String, completion: (() -> Void)? = nil) {
		cache.removeObject(forKey: key as AnyObject)
		completion?()
	}

	public func removeAll(completion: (() -> Void)? = nil) {
		cache.removeAllObjects()
		completion?()
	}
	
	
	// MARK: - Synchronous
	
	public subscript(key: String) -> T? {
		get {
			return (cache.object(forKey: key as AnyObject) as? Box<T>)?.value
		}
		
		set(newValue) {
			if let newValue = newValue {
				cache.setObject(Box(newValue), forKey: key as AnyObject)
			} else {
				cache.removeObject(forKey: key as AnyObject)
			}
		}
	}
}
