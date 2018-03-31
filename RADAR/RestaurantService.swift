//
//  RestaurantService.swift
//  RADAR
//
//  Created by Rosalia Dupont on 9/2/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import Firebase

struct RestaurantService{
    
    static func isRestaurantAlive(forKey restaurantKey: String, completion: @escaping (Restaurant?) -> Void) {
        let ref = Database.database().reference().child("alive-restaurants").child(restaurantKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let restaurant = Restaurant(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(restaurant)
            
        })
        
    }

}
