//
//  User.swift
//  Huddle
//
//  Created by Michael Lin on 4/1/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import PromiseKit


/**
 A codable structure representing huddle user.
 */
struct User: Codable {
    
    private(set) var UID: String
    
    var username: String
    var firstname: String
    var lastname: String
    var email: String
    
    fileprivate static var userList: [User] = []
    
    /**
     Get a promise of the user instance identified by UID. Fetched results are cached in an array for faster access.
     */
    static func getUser(withUID UID: String) -> Promise<User> {
        return Promise<User> { seal in
            if let user = userList.filter({$0.UID == UID}).first {
                seal.fulfill(user)
                return
            }
            
            let database = Firestore.firestore()
            database.collection("users").document(UID).getDocument(source: .server) { (document, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                if let document = document, document.exists {
                    let result = Swift.Result {
                        try document.data(as: User.self)
                    }
                    switch result {
                    case .success(let user):
                        if let user = user {
                            self.userList.append(user)
                            seal.fulfill(user)
                        } else {
                            seal.reject(UserAccessError.EmptyUser)
                        }
                    case .failure(let error):
                        seal.reject(UserAccessError.DecodeError(error))
                    }
                } else {
                    seal.reject(UserAccessError.UserNotFound)
                }
            }
        }
    }
    
    enum UserAccessError: Error {
        case UserNotFound
        case DecodeError(Error)
        case EmptyUser
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.UID == rhs.UID
    }
}
