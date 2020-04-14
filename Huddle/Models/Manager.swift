//
//  Manager.swift
//  Huddle
//
//  Created by Michael Lin on 3/14/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

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
    
    /**
    Setup dynamic update of Huddle instances with firebase, the handler is triggered whenever an update occured in Huddle instance node.
     - parameter completionHandler: Callback function after Huddle list has been populated.
     */
    func setupHuddleUpdate(completionHandler: @escaping ([Huddle])->Void) {
        var huddleList: [Huddle] = []
        let firebaseRef = Database.database().reference()
        let huddleRef = firebaseRef.child("/Huddle_instances/Berkeley")
        huddleRef.observe(.value , with: { (snapshot) in
            guard let huddleDict = snapshot.value as? [String: [String: Any]] else {
                NSLog("Error reading from firebase: malformed database format")
                return
            }
            
            for (id, info) in huddleDict {
                let name = info["name"] as! String
                let desc = info["description"] as! String
                let lat: Double = info["lat"] as! Double
                let long: Double = info["long"] as! Double
                let huddle = Huddle(withLocation: CLLocation(latitude: lat, longitude: long), name: name, description: desc, identifier: id)
                huddleList.append(huddle)
            }
            
            huddleList.sort(by: {$0.participants.count > $1.participants.count})
            
            completionHandler(huddleList)
        })
    }
}
