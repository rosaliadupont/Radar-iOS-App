//
//  UserProfileVC.swift
//  RADAR
//
//  Created by Raghav Sreeram on 10/8/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var college: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var interests: UITextField!
    @IBOutlet weak var mainPic: UIImageView!
    @IBOutlet weak var secondPic: UIImageView!
    @IBOutlet weak var thirdPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPic.clipsToBounds = true
        mainPic.layer.masksToBounds = true
        mainPic.layer.cornerRadius = 5
        secondPic.clipsToBounds = true
        secondPic.layer.masksToBounds = true
        secondPic.layer.cornerRadius = 5
        thirdPic.clipsToBounds = true
        thirdPic.layer.masksToBounds = true
        thirdPic.layer.cornerRadius = 5
      
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        var ref = Database.database().reference().child("userData").child("\(User.current.fbid)")
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
        var dict = snapshot.value as! NSDictionary
            
            var mainImgURL = dict["mainPic"] as! String
            
            if let url = URL(string: mainImgURL){
                self.mainPic.kf.setImage(with: url)
            }
            
            var secondImgURL = dict["secondPic"] as! String
            
            if let url = URL(string: mainImgURL){
                self.secondPic.kf.setImage(with: url)
            }
            var thirdImgURL = dict["thirdPic"] as! String
            
            if let url = URL(string: thirdImgURL){
                self.thirdPic.kf.setImage(with: url)
            }
            
            self.displayName.text = dict["displayName"] as! String
            self.college.text = dict["college"] as! String
            self.age.text = "\(dict["age"] as! Int)"
            self.gender.text = dict["gender"] as! String
            self.interests.text = dict["interests"] as! String
            
            
            
        }) { (error) in
            print(error)
        }
    }
    
    
    
    var selectedImage = 1
    @IBAction func mainPic(_ sender: Any) {
        selectedImage = 1
        openImagePicker()
    }
    
    @IBAction func secondPic(_ sender: Any) {
        selectedImage = 2
        openImagePicker()
    }
    @IBAction func thirdPic(_ sender: Any) {
        selectedImage = 3
        openImagePicker()
    }
    func openImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func saveButton(_ sender: Any) {
        
        var ref = Database.database().reference().child("userData").child("\(User.current.fbid)")
        ref.updateChildValues(["displayName": displayName.text, "college": college.text, "age": Int(age.text!), "gender": gender.text, "interests": interests.text])
        
        if(mainPic.image != nil){
            var s = saveImageToFirebase(img: mainPic.image!, index: "mainPic")
           
        }
        if(secondPic.image != nil){
            var s = saveImageToFirebase(img: secondPic.image!, index: "secondPic")
         
        }
        
        if(thirdPic.image != nil){
            var s = saveImageToFirebase(img: thirdPic.image!, index: "thirdPic")
           
        }
        
        
        
        
        
    }
    
    func saveImageToFirebase(img: UIImage, index: String) -> String{
        
        var ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://radar-4b117.appspot.com/")

        var userRef = ref.child("usersData").child("\(User.current.fbid)")
 
        var data = NSData()
        data = UIImageJPEGRepresentation(img, 1.0)! as NSData
       
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        var downloadURL: String = ""
        //Creates storage ref and saves new Image
        storage.child("userPics/\(User.current.fbid)/\(index)").putData(data as Data, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                downloadURL = metaData!.downloadURL()!.absoluteString
                var ref = Database.database().reference().child("userData").child("\(User.current.fbid)")
                ref.updateChildValues(["\(index)": downloadURL])
            }
        }
        
        return downloadURL
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            switch (selectedImage){
            case 1:
            mainPic.contentMode = .scaleToFill
            mainPic.image = pickedImage
            case 2:
            secondPic.contentMode = .scaleToFill
                secondPic.image = pickedImage
            case 3:
                thirdPic.contentMode = .scaleToFill
                thirdPic.image = pickedImage
            default:
                mainPic.contentMode = .scaleToFill
                mainPic.image = pickedImage
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
