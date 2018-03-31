//
//  CheckInViewController.swift
//  RADAR
//
//  Created by Rosalia Dupont on 8/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CheckInViewController: UIViewController {

    @IBOutlet weak var restRating: UILabel!
    @IBOutlet weak var restPrice: UILabel!
    @IBOutlet weak var restReviews: UILabel!
    @IBOutlet weak var restPhoneNum: UILabel!
    @IBOutlet weak var restAddress: UILabel!
    @IBOutlet weak var restOpenOrClosed: UILabel!
    @IBOutlet weak var restImageView: UIImageView!
    var restaurant: Restaurant = Restaurant()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: restaurant.image_url){
            restImageView.kf.setImage(with: url)
        }
        
        restaurantName.text = restaurant.name
        restRating.text = "Rating: \(restaurant.rating)"
        restPrice.text = restaurant.price
        restReviews.text = "\(restaurant.reviewCount) Reviews"
        restPhoneNum.text = restaurant.phoneNumber
        restAddress.text = restaurant.displayAddress[0] + "\n" + restaurant.displayAddress[1]
        if(restaurant.isClosed == true){
            restOpenOrClosed.text = "Closed!"
        }else{
            restOpenOrClosed.text = "Open!"
        }
        print("\(#function):: \(restaurant.printRestInfo())")
        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBAction func checkinButtonTapped(_ sender: Any) {
        let maxRadius = 2410.4016
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            if error != nil {
                
                self.alertMessage(message: (error?.localizedDescription)!, buttonText: "OK", completionHandler: nil)
                return
            }
            guard let _ = location else {
                return
            }
            
            
            let restaurantLocation = CLLocation(latitude: self.restaurant.latitude, longitude: self.restaurant.longitude)
            let distanceFromRest = Double((location?.distance(from: restaurantLocation))!)
            
            if maxRadius < distanceFromRest {
                self.showAlert()
            }
            else {
                self.restaurant.checkedInPeople += 1
                CheckInService.create(restaurant: self.restaurant, completion: { (succeeded) in
                    
                    if succeeded! {
                        print("YYAYY SUCCESSS")
                        //here segue to the people view controller
                        
                        self.performSegue(withIdentifier: "toTempBioVC", sender: self.restaurant)
                        
                    }
                    else {
                        print("check in service failed")
                        self.showAlert() //later in the future maybe change this alert
                        
                    }
                })
                
            }
            
        }    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toTempBioVC"){
            if let destination = segue.destination as? TempBioVC{
                destination.restaurant = sender as! Restaurant
            }
            
        }
    }
    
    
    func showAlert() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "checkInAlert")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(myAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func openMapButtonTapped(_ sender: Any) {
        let coordinate: CLLocationCoordinate2D  = CLLocationCoordinate2DMake(restaurant.latitude,restaurant.longitude);
        openMapsAppWithDirections(to: coordinate, destinationName: restaurant.name)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    func alertMessage(message:String,buttonText:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title: "Location", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

