//
//  User.swift
//  Huddle
//
//  Created by Michael Lin on 4/1/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation

class User: Equatable {
    
    private static var userList: [User] = []
    
    let username: String!
    let email: String!
    
    required init(withUsername username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    /**
     Factory function for creating new user, identified by `username`.
     - returns: If an user with `username` already exists in `User.userList`, return this user, otherwise create a new user instance with `username` and `email`.
     */
    static func getNewUser(withUsername username: String, email: String) -> User {
        let existed = userList.filter({$0.username == username})
        if existed.count == 1 {
            return existed.first!
        } else {
            let user = User(withUsername: username, email: email)
            User.userList.append(user)
            return user
        }
    }
    
    static func getUser(withUsername username: String, email: String) -> User? {
        let existed = userList.filter({$0.username == username})
        if existed.count == 1 {
            return existed.first
        } else {
            return nil
        }
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
    }
}
