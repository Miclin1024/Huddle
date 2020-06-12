//
//  Huddle.swift
//  Huddle
//
//  Created by Michael Lin on 4/1/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import PromiseKit

struct Huddle: Codable {
    
    var description: String
    var host: String
    var location: GeoPoint
    var name: String
    var users: [String]
    var locationDescription: String
    
    static func listHuddle(where filter: (Huddle)->Bool = {_ in return true}) -> Promise<[Huddle]> {
        return Promise { seal in
            let database = Firestore.firestore()
            
        }
    }
    
    /**
    Setup dynamic update of Huddle instances with firebase, the callback is triggered whenever an update occured in Huddle instance node. The list is sorted by number of user, descending.
     - parameter updateCallback: Callback function after Huddle list has been populated.
     */
    static func setupUpdate(updateCallback: @escaping ([Huddle])->Void) {
        let database = Firestore.firestore()
        database.collection("huddles").addSnapshotListener { querySnapshot, error in
            if let error = error {
                NSLog("Error fetching huddles: \(error)")
                return
            }
            if let documents = querySnapshot?.documents {
                var huddles: [Huddle] = []
                for document in documents {
                    let result = Swift.Result {
                        try document.data(as: Huddle.self)
                    }
                    switch result {
                    case .success(let huddle):
                        if let huddle = huddle {
                            huddles.append(huddle)
                        }
                    case .failure(let error):
                        NSLog("Unable to decode: \(error)")
                    }
                }
                
                huddles.sort(by: { (lhs, rhs) in
                    return lhs.users.count > rhs.users.count
                })
                
                updateCallback(huddles)
            }
        }
    }
    
    enum HuddleQueryError: Error {
        case DecodeError(Error)
        case HuddleNotFound
    }
}

extension GeoPoint {
    public func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
