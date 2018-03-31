//
//  UserData.swift
//  RADAR
//
//  Created by Rosalia Dupont on 9/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserData {
    
    var education = ""
    var birthday = ""
    var age = 0
    var url = ""
    var fbID = ""
    
    init(fbID: String){
        self.fbID = fbID
        self.loadData()
    }
    
    func loadData() {
        // load education
        Database.database().reference().child("userData").child(fbID).child("education").observeSingleEvent(of: .value, with: { (snapshot) in
          
            if snapshot.exists(){
                let values = snapshot.value as! [String:String]
                for pair in values{
                    if pair.value.contains("@"){ //most recent education has user email as value
                        self.education = pair.key
                        break
                    }
                }
                NSLog("education loaded")
            }
            else{
                NSLog("education load error")
            }
        })
        // load birthday, age
        Database.database().reference().child("userData").child(fbID).child("birthday").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.exists(){
                self.birthday = snapshot.value as! String
                self.age = self.calcAge(birthday: self.birthday)
                print(self.fbID + " is " + String(self.age) + " years old")
            }
            
        })
        //set facebook profile picture url
        self.url = "https://graph.facebook.com/" + self.fbID + "/picture?type=large"
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
}
