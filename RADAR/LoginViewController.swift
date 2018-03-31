//
//  LoginViewController.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/29/17.
//  Copyright © 2017 Make School. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseFacebookAuthUI

import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin


typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let lower : UInt32 = 1
        let upper : UInt32 = 36
        let randomNumber = arc4random_uniform(upper - lower) + lower
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageViewBackground.image = UIImage(named: String(randomNumber))
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imageViewBackground.frame.size.width, height: imageViewBackground.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.35)
        imageViewBackground.addSubview(overlay)
        
        // Do any additional setup after loading the view.
        
        /*//add Facebook Login Button
        let loginBut = FBSDKLoginButton()
        loginBut.center = self.view.center
        loginBut.delegate = self
        loginBut.readPermissions = ["public_profile", "user_friends", "user_likes", "user_education_history", "user_work_history"]
        self.view.addSubview(loginBut)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        //manage Facebook Login
        facebookLoginManager()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //this is for normal login
        let loginManager = LoginManager()
        loginManager.logIn([.custom("user_likes"), .email, .userFriends, .publicProfile, .custom("user_education_history"), .custom("user_birthday")], viewController: self, completion: {(loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let _):
                self.facebookLoginManager()
                print("Facebook Logged in!")
            }
        })
    }
    
    func facebookLoginManager(){
        if FBSDKAccessToken.current() != nil{
            UserService.getFBUser(forFBID: FBSDKAccessToken.current().userID, completion: {(user) in
                if let currentUser = user{
                    // not a new user
                    NSLog("Not a new user!")
                    NSLog(currentUser.email)
                    //handle existing user
                    User.setCurrent(currentUser, writeToUserDefaults: true)
                    
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                else{
                    // new facebook user
                    NSLog("New Facebook User!")
                    self.performSegue(withIdentifier: Constants.segue.toCreateUsername, sender: self) // have new user create a username
                }
            })
        }
        else{
        }
    }
    
}

/*extension LoginViewController: FBSDKLoginButtonDelegate{
    
    // handle Facebook Login
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            NSLog("Facebook Login Error ☹️")
            print(error.localizedDescription)
            print("DONT FORGET TO ADD POP-UP EXPLAINING THE REASON")
            return
        }
        else {
            NSLog("Facebook Login Success!")
            loginButton.removeFromSuperview()
            let loadView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            loadView.center = self.view.center
            self.view.addSubview(loadView)
            facebookLoginManager()
        }
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // Facebook user logged out
    }
    
}*/


/*extension LoginViewController: FUIAuthDelegate{
 
 func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
 
 if let _ = error { //this is an error handler for loging in
 print("Error signing in")
 return
 
 }
 
 guard let user = user
 else { return }
 
 UserService.show(forUID: user.uid) { (user) in
 if let user = user {
 
 //handle existing user
 User.setCurrent(user, writeToUserDefaults: true)
 
 let initialViewController = UIStoryboard.initialViewController(for: .main)
 self.view.window?.rootViewController = initialViewController
 self.view.window?.makeKeyAndVisible()
 }
 
 else {
 // handle new user
 self.performSegue(withIdentifier: Constants.segue.toCreateUsername, sender: self)
 }
 
 }
 }
 }*/
