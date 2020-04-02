//
//  Huddle.swift
//  Huddle
//
//  Created by Michael Lin on 4/1/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation

class Huddle {
    
    let location: CLLocation!
    let name: String!
    let description: String?
    var participants: [User] = []
    
    required init (withLocation location: CLLocation, name: String, description: String?, participants: [User] = []) {
        self.location = location
        self.name = name
        self.description = description
        self.participants.append(contentsOf: participants)
    }
}
