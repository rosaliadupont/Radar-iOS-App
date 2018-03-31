//
//  TempBioVC.swift
//  RADAR
//
//  Created by Raghav Sreeram on 10/15/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase

class TempBioVC: UIViewController {
    
    var restaurant: Restaurant!

    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "toPeopleVC", sender: self.restaurant)
       var ref = Database.database().reference().child("userData").child("\(User.current.fbid)")
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var dic = snapshot.value as! NSDictionary
            
            var imageURL = dic["mainPic"] as! String
            
            if let url = URL(string: imageURL){
                self.mainPic.kf.setImage(with: url)
            }
            
        }) { (error) in
            print(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toPeopleVC"){

            if let destination = segue.destination as? PeopleViewController{

                destination.restaurant = sender as! Restaurant
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTempBio(_ sender: Any) {
        
        var ref = Database.database().reference().child("userData").child(User.current.fbid)
        
        ref.updateChildValues(["bio": bioField.text!])

        self.performSegue(withIdentifier: "toPeopleVC", sender: self.restaurant)
  
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
