//
//  PublicFunc.swift
//  MemoryInMap
//
//  Created by wangkan on 16/7/28.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit

//TODO: 实现传入self
public func getBarHeight(_ viewController: AnyObject) -> CGFloat {
	//let heightNavBar = self.navigationController!.navigationBar.frame.height ?? 0
	let heightStatusBar = UIApplication.shared.statusBarFrame.height 
	//return heightNavBar + heightStatusBar
    return heightStatusBar
}
<<<<<<< HEAD
=======

func CreateImageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}


func imageFromContextOfSize(_ size: CGSize, closure: @escaping(_ size:CGSize) -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure(size)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

func imageOfSize(_ size:CGSize, closure: @escaping (_ size:CGSize) -> ()) -> UIImage {
    if #available(iOS 10.0, *) {
        let r = UIGraphicsImageRenderer(size:size)
        return r.image {
            _ in closure(size)
        }
    } else {
        return imageFromContextOfSize(size, closure: closure)
    }
}

/// 传入T-配置T
func lend<T> (_ closure:(T)->()) -> T where T: NSObject {
    let orig = T()
    closure(orig)
    return orig
}
>>>>>>> master
