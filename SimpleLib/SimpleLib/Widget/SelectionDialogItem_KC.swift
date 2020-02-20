//
//  SelectionDialogItem_KC.swift
//  Sample
//
//  Created by LeeSunhyoup on 2015. 9. 29..
//  Copyright © 2015 KCSelectionView. All rights reserved.
//

import UIKit

public class SelectionDialogItem_KC: NSObject {
    
    var icon: UIImage?
    var itemTitle: String
    var handler: (() -> Void)?
    var font: UIFont?
    
    public typealias CompletionBlock = () -> Void
    
    public init(item itemTitle: String) {
        self.itemTitle = itemTitle
    }
    
    public init(item itemTitle: String, icon: UIImage) {
        self.itemTitle = itemTitle
        self.icon = icon
    }
    
    public init(item itemTitle: String, didTapHandler: @escaping (() -> Void)) {
        self.itemTitle = itemTitle
        self.handler = didTapHandler
    }
    
    public init(item itemTitle: String, icon: UIImage, didTapHandler: @escaping (() -> Void)) {
        self.itemTitle = itemTitle
        self.icon = icon
        self.handler = didTapHandler
    }
    
    public init(item itemTitle: String, icon: UIImage, font: UIFont, didTapHandler: @escaping CompletionBlock) {
        self.itemTitle = itemTitle
        self.icon = icon
        self.handler = didTapHandler
        self.font = font
    }
    
    @objc func handlerTap() {
        handler?()
    }
}