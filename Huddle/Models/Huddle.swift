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
    
    let identifier: String!
    let location: CLLocation!
    let name: String!
    let description: String?
    let host: String!
    let locString: String!
    var users: [User] = []
    
    required init (withLocation location: CLLocation, locString: String, name: String, description: String?, host: String, users: [User] = [], identifier: String) {
        
        self.location = location
        self.locString = locString
        self.name = name
        self.description = description
        self.users.append(contentsOf: users)
        self.identifier = identifier
        self.host = host
    }
}
