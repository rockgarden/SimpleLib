//
//  LocationMethods.swift
//  MemoryInMap
//
//  Created by wangkan on 16/6/15.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit
import MapKit

public func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    viewController.present(alert, animated: true, completion: nil)
}

public func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}

public func zoomToUserLocationInMapView(mapView: MKMapView, locationManager: CLLocationManager) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let GCJcood = locationManager.WGSToGCJ(coordinate)
        let region = MKCoordinateRegionMakeWithDistance(GCJcood, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}



