//
//  CoordinateConverter.swift
//
//  Created by wangkan on 2016/12/26.
//  Copyright © 2016年 rockgarden. All rights reserved.
//
//  https://github.com/googollee/eviltransform
//
//  https://github.com/nameislihong/TransformCoordinate/blob/master/Map/TransformCoordinate.m
//  https://github.com/skx926/KSCoordinateConverter/blob/master/KSCoordinateConverter/KSCoordinateConverter.m
//

import Foundation

/**
 *  Struct transform coordinate between earth(WGS-84) and mars in china(GCJ-02).
 */
public struct CoordinateConverter {
    
    static let EARTH_R: Double = 6378137.0 //地球半径应该是个var？6378245.0
    /*Krasovsky 1940
     a = 6378245.0, 1/f = 298.3
     b = a * (1 - f)
     ee = (a^2 - b^2) / a^2
     */
    static let ee: Double = 0.00669342162296594323
    
    static func isOutOfChina(_ lat: Double, lng: Double) -> Bool {
        
        if lng < 72.004 || lng > 137.8347 {
            return true
        }
        if lat < 0.8293 || lat > 55.8271 {
            return true
        }
        return false
    }
    
    static func transform(_ x: Double, y: Double) -> (lat: Double, lng: Double) {
        
        let xy = x * y
        let absX = sqrt(fabs(x))
        let xPi = x * M_PI
        let yPi = y * M_PI
        let d = 20.0 * sin(6.0 * xPi) + 20.0 * sin(2.0 * xPi)
        
        var lat = d
        var lng = d
        
        lat += 20.0 * sin(yPi) + 40.0 * sin(yPi / 3.0)
        lng += 20.0 * sin(xPi) + 40.0 * sin(xPi / 3.0)
        
        lat += 160.0 * sin(yPi / 12.0) + 320 * sin(yPi / 30.0)
        lng += 150.0 * sin(xPi / 12.0) + 300 * sin(xPi / 30.0)
        
        lat *= 2.0 / 3.0
        lng *= 2.0 / 3.0
        
        lat += -100 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * xy + 0.2 * absX
        lng += 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * xy + 0.1 * absX
        
        return (lat, lng)
    }
    
    static func delta(_ lat: Double, lng: Double) -> (dLat: Double,  dLng: Double) {
        let radLat = lat / 180.0 * M_PI
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic = sqrt(magic)
        var (dLat, dLng) = transform(lng - 105.0, y: lat - 35.0)
        dLat = (dLat * 180.0) / ((EARTH_R * (1 - ee)) / (magic * sqrtMagic) * M_PI)
        dLng = (dLng * 180.0) / (EARTH_R / sqrtMagic * cos(radLat) * M_PI)
        return (dLat, dLng)
    }
    
    /**
     *  wgs2gcj convert WGS-84 coordinate(wgsLat, wgsLng) to GCJ-02 coordinate(gcjLat, gcjLng).
     */
    public static func wgs2gcj(_ wgsLat: Double, wgsLng: Double) -> (gcjLat: Double, gcjLng: Double) {
        if isOutOfChina(wgsLat, lng: wgsLng) {
            return (wgsLat, wgsLng)
        }
        let (dLat, dLng) = delta(wgsLat, lng: wgsLng)
        return (wgsLat + dLat, wgsLng + dLng)
    }
    
    /**
     *  gcj2wgs convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
     *  The output WGS-84 coordinate's accuracy is 1m to 2m. If you want more exactly result, use gcj2wgs_exact.
     */
    public static func gcj2wgs(_ gcjLat: Double, gcjLng: Double) -> (wgsLat: Double, wgsLng: Double) {
        if isOutOfChina(gcjLat, lng: gcjLng) {
            return (gcjLat, gcjLng)
        }
        let (dLat, dLng) = delta(gcjLat, lng: gcjLng)
        return (gcjLat - dLat, gcjLng - dLng)
    }
    
    /**
     *  gcj2wgs_exact convert GCJ-02 coordinate(gcjLat, gcjLng) to WGS-84 coordinate(wgsLat, wgsLng).
     *  The output WGS-84 coordinate's accuracy is less than 0.5m, but much slower than gcj2wgs.
     */
    public static func gcj2wgs_exact(_ gcjLat: Double, gcjLng: Double) -> (wgsLat: Double, wgsLng: Double) {
        let initDelta = 0.01, threshold = 0.000001
        var (dLat, dLng) = (initDelta, initDelta)
        var (mLat, mLng) = (gcjLat - dLat, gcjLng - dLng)
        var (pLat, pLng) = (gcjLat + dLat, gcjLng + dLng)
        var (wgsLat, wgsLng) = (gcjLat, gcjLng)
        for _ in 0 ..< 30 {
            (wgsLat, wgsLng) = ((mLat + pLat) / 2, (mLng + pLng) / 2)
            let (tmpLat, tmpLng) = wgs2gcj(wgsLat, wgsLng: wgsLng)
            (dLat, dLng) = (tmpLat - gcjLat, tmpLng - gcjLng)
            if (fabs(dLat) < threshold) && (fabs(dLng) < threshold) {
                return (wgsLat, wgsLng)
            }
            if dLat > 0 {
                pLat = wgsLat
            } else {
                mLat = wgsLat
            }
            if dLng > 0 {
                pLng = wgsLng
            } else {
                mLng = wgsLng
            }
        }
        return (wgsLat, wgsLng)
    }
    
    /**
     *  Distance calculate the distance between point(latA, lngA) and point(latB, lngB), unit in meter.
     */
    public static func Distance(_ latA: Double, lngA: Double, latB: Double, lngB: Double) -> Double {
        let arcLatA = latA * M_PI / 180
        let arcLatB = latB * M_PI / 180
        let x = cos(arcLatA) * cos(arcLatB) * cos((lngA-lngB) * M_PI/180)
        let y = sin(arcLatA) * sin(arcLatB)
        var s = x + y
        if s > 1 {
            s = 1
        }
        if s < -1 {
            s = -1
        }
        let alpha = acos(s)
        let distance = alpha * EARTH_R
        return distance
    }
}

extension CoordinateConverter {
    
    public static func gcj2bd(_ gcjLat: Double, gcjLng: Double) -> (bdLat: Double, bdLng: Double) {
        if isOutOfChina(gcjLat, lng: gcjLng) {
            return (gcjLat, gcjLng)
        }
        let x = gcjLng, y = gcjLat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI)
        let theta = atan2(y, x) + 0.000003 * cos(x * M_PI)
        let bdLng = z * cos(theta) + 0.0065
        let bdLat = z * sin(theta) + 0.006
        return (bdLat, bdLng)
    }
    
    public static func bd2gcj(_ bdLat: Double, bdLng: Double) -> (gcjLat: Double, gcjLng: Double) {
        if isOutOfChina(bdLat, lng: bdLng) {
            return (bdLat, bdLng)
        }
        let x = bdLng - 0.0065, y = bdLat - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI)
        let theta = atan2(y, x) - 0.000003 * cos(x * M_PI)
        let gcjLng = z * cos(theta)
        let gcjLat = z * sin(theta)
        return (gcjLat, gcjLng)
    }
    
    public static func wgs2bd(_ wgsLat: Double, wgsLng: Double) -> (bdLat: Double, bdLng: Double) {
        let (gcjLat, gcjLng) = wgs2gcj(wgsLat, wgsLng: wgsLng)
        return gcj2bd(gcjLat, gcjLng: gcjLng)
    }
    
    public static func bd2wgs(_ bdLat: Double, bdLng: Double) -> (wgsLat: Double, wgsLng: Double) {
        let (gcjLat, gcjLng) = bd2gcj(bdLat, bdLng: bdLng)
        return gcj2wgs(gcjLat, gcjLng: gcjLng)
    }
}
