//
//  CheckInService.swift
//  RADAR
//
//  Created by Rosalia Dupont on 9/1/17.
//  Copyright © 2017 Make School. All rights reserved.
//
import Foundation
import FirebaseDatabase
import UIKit

struct CheckInService {
    
    static func create(restaurant: Restaurant, completion: @escaping (Bool?)->Void ){
        
        let currentUser = User.current
        
        let newLatitude = String(restaurant.latitude).replacingOccurrences(of: ".", with: "&")
        let newLongitude = String(restaurant.longitude).replacingOccurrences(of: ".", with: "&")
        let restaurantKey = "\(newLatitude)-\(newLongitude)"
        let rootRef = Database.database().reference()
        
        
        let restaurantDict: [String : Any] = ["name" : restaurant.name,
                                              "checked-in-people" : restaurant.checkedInPeople]
        var updatedData: [String : Any] = ["alive-restaurants/\(restaurantKey)" : restaurantDict]
        updatedData["checked-in-people/\(restaurantKey)/\(currentUser.fbid)"] = currentUser.username
        // first check if user already checked in to this place -
        if UserDefaults.standard.object(forKey: restaurantKey + currentUser.fbid) != nil{
            let time = UserDefaults.standard.integer(forKey: restaurantKey + currentUser.fbid)
            let diff = (Int(Date().timeIntervalSince1970) - time)/(60*60)
            if diff > 2{
                return completion(false)
            }
        }
        
        rootRef.updateChildValues(updatedData, withCompletionBlock: { (error, _) in
            
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(false)
            }
                
            else {
                // set check in time in user defaults
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: restaurantKey + currentUser.fbid)
                return completion(true)
            }
        })
        
        
    }
}
