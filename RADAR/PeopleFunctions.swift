//
//  PeopleFunctions.swift
//  RADAR
//
//  Created by Dhawal Majithia on 9/3/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PeopleFunctions {
    
    static func getUsersCheckedIn(at restKey: String, completion: @escaping ([User]) -> Void){
        
        Database.database().reference().child("checked-in-people").child(restKey).observeSingleEvent(of: .value, with:{(snapshot) in
            if snapshot.exists(){
                // TODO: 1)remove users already swiped on 2) sort users. Users that swiped on current user should show up first!
                let userDict = snapshot.value as? [String:Any]
                var users = [User]()
                Database.database().reference().child("relativeScores/" + restKey + "/" + User.current.fbid).observeSingleEvent(of: .value, with: {(anotherSnapshot) in
                    for fbID in (userDict?.keys)!{
                        UserService.show(forUID: fbID, completion: {(user) in
                            users.append(user!)
                            if(users.count == userDict?.count){
                                //now we sort users
                                if anotherSnapshot.exists(){
                                    let scores = anotherSnapshot.value as! [String:Double]
                                    users.sort(by: {(u1, u2) in
                                        let s1 = (scores[u1.fbid] != nil) ? scores[u1.fbid]! : 0.0
                                        let s2 = (scores[u2.fbid] != nil) ? scores[u2.fbid]! : 0.0
                                        return s1 < s2
                                    })
                                }
                                completion(users)
                            }
                        })
                    }
                })

            }
            else {completion([])}
        })
    }
    
    
    static func rightSwipeOn(fbID: String, restKey: String, completion: @escaping (Bool) -> Void){
        addRightSwipeToDatabase(fbID: fbID, restKey: restKey)
        // now, check if matched
        Database.database().reference().child("rightSwipes").child(restKey).child(fbID).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                let swipedUsers = snapshot.value as! [String:String] // [fbID:username of swiper]
                if swipedUsers[User.current.fbid] != nil{ // other user has swiped right too! Yay!
                    // TODO: store "match" to Firebase
                    completion(true)
                }
                else{
                    completion(false) // other user has swiped on people, but not on current user
                }
            }
            else{
                completion(false) // other user has not swiped on anyone yet
            }
            
        })
    }
    
    // called internally by rightSwipeOns
    static func addRightSwipeToDatabase(fbID: String, restKey: String){ // swipe data is stored as - restKey->fbID of swiping user->fbID of swiped user : username of swiping user
        let swipeData = [fbID : User.current.username]
        Database.database().reference().child("rightSwipes").child(restKey).child(User.current.fbid).setValue(swipeData)
    }
    
}
