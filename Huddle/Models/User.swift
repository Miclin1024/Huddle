//
//  User.swift
//  Huddle
//
//  Created by Michael Lin on 4/1/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation

class User {
    
    let uuid: String!
    let username: String!
    
    required init(uuid: String, username: String) {
        self.uuid = uuid
        self.username = username
    }
}
