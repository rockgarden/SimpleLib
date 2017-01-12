//
//  DiskCache.swift
//  Cache
//
//  Created by Sam Soffes on 5/6/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

/// Disk cache. All reads run concurrently. Writes wait for all other queue actions to finish and run one at a time
/// using dispatch barriers.
//TODO: NSCoding
public struct DiskCache<T: NSCoding>: Cache {
    
    // MARK: - Properties
    
    fileprivate let directory: String
    fileprivate let fileManager = FileManager()
    fileprivate let queue = DispatchQueue(label: "com.samsoffes.cache.disk-cache", attributes: DispatchQueue.Attributes.concurrent)
    
    
    // MARK: - Initializers
    
    public init?(directory: String) {
        var isDirectory: ObjCBool = false
        // Ensure the directory exists
        if fileManager.fileExists(atPath: directory, isDirectory: &isDirectory) && isDirectory {
            self.directory = directory
            return
        }
        
        // Try to create the directory
        do {
            try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            self.directory = directory
        } catch {}
        
        return nil
    }
    
    
    // MARK: - Cache
    
    public func get(key: String, completion: @escaping ((T?) -> Void)) {
        let path = pathForKey(key)
        
        coordinate {
            let value = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? T
            completion(value)
        }
    }
    
    public func set(key: String, value: T, completion: (() -> Void)? = nil) {
        let path = pathForKey(key)
        let fileManager = self.fileManager
        /// barrier: 假设我们有一个并发的队列用来读写一个数据对象。如果这个队列里的操作是读的，那么可以多个同时进行。如果有写的操作，则必须保证在执行写入操作时，不会有读取操作在执行，必须等待写入完成后才能读取，否则就可能会出现读到的数据不对。
        coordinate(barrier: true) {
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {}
            }
            
            NSKeyedArchiver.archiveRootObject(value, toFile: path)
        }
    }
    
    public func remove(key: String, completion: (() -> Void)? = nil) {
        let path = pathForKey(key)
        let fileManager = self.fileManager
        
        coordinate {
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {}
            }
        }
    }
    
    /**
     FIXME:对tempDirectory = NSTemporaryDirectory()的文件无效
     
     - parameter completion: <#completion description#>
     */
    public func removeAll(completion: (() -> Void)? = nil) {
        let fileManager = self.fileManager
        let directory = self.directory
        
        coordinate {
            guard let paths = try? fileManager.contentsOfDirectory(atPath: directory) else { return }
            
            for path in paths {
                do {
                    try fileManager.removeItem(atPath: path)
                } catch {}
            }
        }
    }
    
    
    // MARK: - Private
    
    fileprivate func coordinate(barrier: Bool = false, block: @escaping () -> Void) {
        if barrier {
            queue.async(flags: .barrier, execute: block)
            return
        }
        queue.async(execute: block)
    }
    
    fileprivate func pathForKey(_ key: String) -> String {
        return (directory as NSString).appendingPathComponent(key)
    }
    
    func cleanTemp() {
        var res = Array<Date>()
        do {
            if let tmpFiles = try? fileManager.contentsOfDirectory(atPath: directory) {
                for file in tmpFiles {
                    let fullPath = (file as NSString).appendingPathComponent(file)
                    if fileManager.fileExists(atPath: fullPath) {
                        do {
                            try fileManager.removeItem(atPath: fullPath)
                        } catch {}
                    }
                    do {
                        
                        if let attr: NSDictionary = try! fileManager.attributesOfItem(atPath: file) as NSDictionary? {
                            res.append(attr.fileModificationDate()!)
                        }
                    }
                    
                }
            }
        }
        debugPrint(res)
    }
}

extension DiskCache {
    
    //    //清除指定缓存(需加上后缀名，如: 123.mp3)
    //    func cleanCacheFileWithCacheKey(cacheKey:String){
    //        let fullPath = self.cacheFilePath.stringByAppendingPathComponent(cacheKey)
    //        let manager = NSFileManager.defaultManager()
    //        if manager.fileExistsAtPath(fullPath){
    //            manager.removeItemAtPath(fullPath, error: nil)
    //        }
    //    }
    
    //获取tmp文件列表(相对路径，如:[123.mp3,234.mp3])
    //    func cachesList() -> Array<String>? {
    //        do{
    //            if let tmpFiles = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(temporaryDirectory)
    //            {
    //                return tmpFiles
    //            }
    //        }
    //    }
    
    //    //获取缓存文件完整目录列表
    //    func cacheFileFullPathes() -> Array<String>{
    //        var res = Array<String>()
    //        var arr = self.cachesList()
    //        if arr != nil{
    //            for item in arr!{
    //                res.append(XXYAudioEngine.cacheFilePath.stringByAppendingPathComponent(item))
    //            }
    //        }
    //        return res
    //    }
    
    //    //获取缓存大小(单位：MB)
    //    func cacheSize() -> Float{
    //        var fileList = self.cacheFileFullPathes()
    //        var totalSize = UInt64(0)
    //        for item in fileList{
    //            let attr:NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(item, error: nil)!
    //            totalSize += attr.fileSize()
    //        }
    //        return Float(totalSize)/(1024*1024)
    //    }
    
    //    //获取各个缓存文件的下载完成时间
    //    func cacheFinishedDownLoadDates() -> Array<NSDate>{
    //        var fileList = self.cacheFileFullPathes()
    //        var res = Array<NSDate>()
    //        for item in fileList{
    //            do {
    //            let attr:NSDictionary = NSFileManager.defaultManager().attributesOfItemAtPath(item, error: nil)!
    //            }catch {
    //
    //            }
    //            if attr.fileModificationDate() != nil{
    //                res.append(attr.fileModificationDate()!)
    //            }else{
    //                res.append(NSDate())
    //            }
    //        }
    //        return res
    //    }
}
