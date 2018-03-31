//
//  Restaurant.swift
//  RADAR
//
//  Created by Rosalia Dupont on 8/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import Firebase

class Restaurant {
    
    var id = ""
    var name = ""
    var miles: Double = 0
    var image_url = ""
    var longitude:Double = 0
    var latitude:Double = 0
    var checkedInPeople = 0
    
    init(){
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
        let checkedInPeople = dict["checked-in-people"] as? Int
            else { return nil }
        
        self.checkedInPeople = checkedInPeople
    }
    
    var rating: Double = 0
    var phoneNumber: String = " "
    var price: String = " "
    var displayAddress: [String] = ["ad1", "ad2"]
    var isClosed: Bool = true
    var reviewCount: Int = 0
    
    func printRestInfo() -> String{
        return "\(id), \(name), \(miles), \(image_url), \(longitude), \(latitude), \(rating), \(phoneNumber), \(price), \(displayAddress), \(isClosed), \(reviewCount)"
    }
    
    
}
