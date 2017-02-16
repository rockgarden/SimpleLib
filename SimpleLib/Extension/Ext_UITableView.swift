//
//  ExtKIT
//  Ext_UITableView.swift
//
//
//  Created by wangkan on 16/6/27.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

public extension UITableView {
    
    public func indexPathForAbsoluteRow(absoluteRow: Int) -> NSIndexPath?{
        var currentRow = 0
        for section in 0..<numberOfSections{
            for row in 0..<numberOfRows(inSection: section){
                if currentRow == absoluteRow{
                    return NSIndexPath(forRow: row, inSection: section)
                }
                currentRow += 1
            }
        }
        return nil
    }
    
    public func absoluteRowForIndexPath(indexPath: NSIndexPath) -> Int?{
        guard indexPath.section < self.numberOfSections else { return nil }
        var rowNumber = 0
        for section in 0..<indexPath.section{
            rowNumber += numberOfRows(inSection: section)
        }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return nil }
        rowNumber += indexPath.row
        return rowNumber
    }
    
    public func numberOfTotalRows() -> Int{
        var total = 0
        for section in 0..<numberOfSections{
            total += numberOfRows(inSection: section)
        }
        return total
    }
    
}

