//
//  FBService.swift
//  RADAR
//
//  Created by Dhawal Majithia on 9/5/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FirebaseDatabase

struct FBService{
    
    static func storeFBAccessTokenOnFirebase(){
        let  accessToken = FBSDKAccessToken.current().tokenString
        Database.database().reference().child("accessTokens").child(User.current.fbid).setValue(accessToken)
    }
    
    static func storeFBUserFriends(fbid: String){
        FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": "uid"]).start(
            completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    if let userData = result as? [String:Any] {
                        let count = (userData["summary"] as? NSDictionary)?["total_count"] as! Int
                        Database.database().reference().child("userData").child(fbid).child("friendsCount").setValue(count)
                    }
                }
        })
    }
    
    static func storeFBUserLikesOnFirebase(fbid: String)
    {
        FBSDKGraphRequest(graphPath: "me/likes", parameters: ["fields": "target_id"]).start(
            completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    if let userData = result as? [String:Any] {
                        let likesDict = (userData["data"] as? [NSDictionary])
                        var likes = [String:Int]()
                        for pair in likesDict!{
                            likes[pair.allValues[0] as! String] = 1
                        }
                        //print(likes)
                        Database.database().reference().child("userData").child(fbid).child("likes").setValue(likes)
                    }
                }
        })
    }
    
    static func storeFBUserEducation(fbid: String){
        FBSDKGraphRequest(graphPath: "me/", parameters: ["fields": "education"]).start(
            completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil){
                if let userData = result as? [String:Any] {
                    //print(userData["education"])
                    for element in (userData["education"] as! NSArray){
                        var year = User.current.email
                        //print((element as! NSDictionary)["year"] as! NSDictionary)
                        if let _ = (element as! NSDictionary)["year"]{
                            year = ((element as! NSDictionary)["year"] as! NSDictionary)["id"] as! String
                        }
                        if let schoolName = ((element as! NSDictionary)["school"] as! NSDictionary)["name"]{
                            let name = (schoolName as! String).replacingOccurrences(of: ".", with: " ")
                            Database.database().reference().child("userData").child(fbid).child("education").child(name).setValue(year)
                        }
                    }
                    //Database.database().reference().child("userData").child(fbid).child("education").setValue(userData["education"])
                }
            }
            else{
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    static func storeFBUserWork(fbid: String){
        FBSDKGraphRequest(graphPath: "me/", parameters: ["fields": "work"]).start(
            completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    if let userData = result as? [String:Any] {
                        print(userData)
                    }
                }
                else{
                    print(error?.localizedDescription as Any)
                }
        })
    }
    
    static func storeFBUserBirthday(fbid: String){
        FBSDKGraphRequest(graphPath: "me/", parameters: ["fields": "birthday"]).start(
            completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    if let userData = result as? [String:String] {
                        let birthday = userData["birthday"]
                        print(birthday!)
                        Database.database().reference().child("userData").child(fbid).child("birthday").setValue(birthday)
                    }
                }
                else{
                    print(error?.localizedDescription as Any!)
                }
        })
    }

    
}
