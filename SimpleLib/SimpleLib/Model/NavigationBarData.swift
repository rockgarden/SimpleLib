//
//  NavigationBarData.swift
//  KMNavigationBarTransition
//
//  Created by Zhouqi Mo on 1/1/16.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

import UIKit

//FIXME: 无法通过动态包调用
struct NavigationBarData {
    
    static let BarTintColorArray: [NavigationBarBackgroundViewColor] = [.Cyan, .Yellow, .Green, .Orange, .lightGray, .NoValue]
    static let BackgroundImageColorArray: [NavigationBarBackgroundViewColor] = [.NoValue, .Transparent, .Cyan, .Yellow, .Green, .Orange, .lightGray]
    
    var barTintColor = NavigationBarData.BarTintColorArray[5]
    var backgroundImageColor = NavigationBarData.BackgroundImageColorArray[1]
    var prefersHidden = false
    var prefersShadowImageHidden = true

}

enum NavigationBarBackgroundViewColor: String {
    case Cyan
    case Yellow
    case Green
    case Orange
    case lightGray
    case Transparent
    case NoValue = "No Value"
    
    var toUIColor: UIColor? {
        switch self {
        case .Cyan:
            return UIColor.cyan
        case .Yellow:
            return UIColor.yellow
        case .Green:
            return UIColor.green
        case .Orange:
            return UIColor.orange
        case .lightGray:
            return UIColor.lightGray
        default:
            return nil
        }
    }
    
    var toUIImage: UIImage? {
        switch self {
        case .Transparent:
            return UIImage()
        default:
            if let color = toUIColor {
                return UIImage(color: color)
            } else {
                return nil
            }
        }
    }
}
