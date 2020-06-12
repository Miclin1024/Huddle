//
//  Manager.swift
//  Huddle
//
//  Created by Michael Lin on 3/14/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation

class Manager {
    
    static let shared = Manager()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    init() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
}
