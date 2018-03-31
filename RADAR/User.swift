//
//  User.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase.FIRDataSnapshot


class User : NSObject {
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    let fbid: String
    let email: String
    let data: UserData
    var isFollowed = false
    
    // MARK: - Init
    
    
    init(uid: String, username: String, fbid: String, email: String){
        self.uid = uid
        self.username = username
        self.fbid = fbid
        self.email = email
        self.data = UserData(fbID: fbid)
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String,
            let uid = dict["uid"] as? String,
            let email = dict["email"] as? String
            //let fbid = dict["fbid"] as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        self.fbid = snapshot.key
        self.email = email
        self.data = UserData(fbID: fbid)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String,
            let fbid = aDecoder.decodeObject(forKey: Constants.UserDefaults.fbid) as? String,
            let email = aDecoder.decodeObject(forKey: Constants.UserDefaults.email) as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        self.fbid = fbid
        self.email = email
        self.data = UserData(fbID: fbid)
        
        super.init()
    }
    
    //MARK: - Current User static var
    
    private static var _current: User?
    
    static var current: User {
        
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        return currentUser
    }
    
    // MARK: - Class Methods
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
        FBService.storeFBAccessTokenOnFirebase()
        FBService.storeFBUserFriends(fbid: user.fbid)
        FBService.storeFBUserLikesOnFirebase(fbid: user.fbid)
        FBService.storeFBUserEducation(fbid: user.fbid)
        FBService.storeFBUserWork(fbid: user.fbid)
        FBService.storeFBUserBirthday(fbid: user.fbid)
        //UserData.sharedInstance.loadData()
    }
    
}


extension User: NSCoding {
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        aCoder.encode(fbid, forKey: Constants.UserDefaults.fbid)
        aCoder.encode(email, forKey: Constants.UserDefaults.email)
    }
}
