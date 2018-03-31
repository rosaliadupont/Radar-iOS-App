//
//  UserService.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth.FIRUser
import FirebaseDatabase
import CoreLocation
import MapKit
import FBSDKCoreKit


//this struct contains all of the user-related networking
//code here


struct UserService {
    
    static func show( forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    /*static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }*/

    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        //create new user
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"]).start(
            completionHandler: { (connection, result, error) -> Void in

                if (error == nil){
                    if let email = (result as! NSDictionary).object(forKey: "email") as? String{
                        Auth.auth().createUser(withEmail: email, password: FBSDKAccessToken.current().userID, completion: {(result) in
                            //new user created in firebase. Email used is FB email, and password is App-Scoped FB ID
                            let userAttrs = ["username": username, "uid": firUser.uid, "email": email]
                            
                            let ref = Database.database().reference().child("users").child(FBSDKAccessToken.current().userID)
                            
                            ref.setValue(userAttrs) { (error, ref) in
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                    return completion(nil)
                                }
                                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                    let user = User(snapshot: snapshot)
                                    completion(user)
                                })
                            }
                            
                        })
                    }
                }})
    }
    
    static func getFBUser(forFBID fbid: String, completion: @escaping (User?) -> Void){
        
        Auth.auth().signInAnonymously(completion: {(result) in
            Database.database().reference().child("users").child(fbid).observeSingleEvent(of: .value, with: { (snapshot) in
                // not a new user
                let user = User(snapshot: snapshot)
                completion(user)
                
            }) { (error) in
                // new user
                NSLog(error.localizedDescription)
                completion(nil)
            }
        })
    }

}

