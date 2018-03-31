//
//  MainViewController.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import CoreLocation

class MainViewController: UIViewController, RadarTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var restaurantAr = [Restaurant]()
    //let refreshControl = UIRefreshControl()
    var userLocation: CLLocation!
    
    
    override func viewDidLoad() {
        
        //configureTableView()
        
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            if error != nil {
                
                self.alertMessage(message: (error?.localizedDescription)!, buttonText: "OK", completionHandler: nil)
                return
            }
            guard let _ = location else {
                return
            }
            if let temporaryNavigationController = self.navigationController
            {
                temporaryNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            }
            
            self.userLocation = location
            
            let url = "https://api.yelp.com/v3/businesses/search"
            
            let accessToken = "ODLS0yK9eGOFXvTXT22pG5cc2vpZrMAxtOIfcGjYK2zXuOfFJD1ci2vsKiyaC6SspkSY-q4AN8eztflhr3yK6u8a5RGFM130ivJoGQkjqoCdAeZJGfBjF9M_ZRp9WXYx"
            let header: HTTPHeaders = ["Authorization" : "Bearer \(accessToken)"]
            let params: Parameters = ["businesses": "price", "latitude" : self.userLocation.coordinate.latitude, "longitude" : self.userLocation.coordinate.longitude]
            
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                
                switch response.result {
                    
                case .success :
                    let json = JSON(with: response.data!)
                    let businesses = json["businesses"].array
                    print(json)
                    
                    for business in businesses!{
                        guard let id = business["id"].string, let name = business["name"].string, let miles = business["distance"].double, let image_url = business["image_url"].string, let longitude = business["coordinates"]["longitude"].double, let latitude = business["coordinates"]["latitude"].double, let rating = business["rating"].double, let phoneNum = business["display_phone"].string, let isClosed = business["is_closed"].bool, let reviewCt = business["review_count"].int, let dispAddress = business["location"]["display_address"].arrayObject else {
                            return
                        }
                        
                        let rest = Restaurant()
                        rest.id = id
                        rest.name = name
                        rest.miles = miles
                        rest.image_url = image_url
                        rest.longitude = longitude
                        rest.latitude = latitude
                        rest.rating = rating
                        rest.phoneNumber = phoneNum
                        
                        if(business["price"].string != nil){
                            rest.price = business["price"].string!
                        }
                        
                        rest.isClosed = isClosed
                        rest.reviewCount = reviewCt
                        rest.displayAddress = dispAddress as! [String]
                        self.restaurantAr.append(rest)
                        
                        
                    }
                    
                    print(self.restaurantAr.count)
                    
                    for i in self.restaurantAr {
                        print("\(i.id)")
                    }
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    
                    self.tableView.reloadData()
                    
                    
                case .failure:
                    print("failure with yelp api")
                    
                }
            }
            
            
        }
        
        super.viewDidLoad()
        
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        LocationManager.sharedInstance.getCurrentReverseGeoCodedLocation { (location:CLLocation?, placemark:CLPlacemark?, error:NSError?) in
            if error != nil {
                
                self.alertMessage(message: (error?.localizedDescription)!, buttonText: "OK", completionHandler: nil)
                return
            }
            guard let _ = location else {
                return
            }
            print(placemark?.addressDictionary?.description ?? "")
            
            let address = placemark?.addressDictionary?["FormattedAddressLines"] as! NSArray
            print(address.description)
            
            print("this is latitude: \((placemark?.location?.coordinate.latitude)!)")
            print( "this is longitude: \((placemark?.location?.coordinate.longitude)!)")
            
            if let temporaryNavigationController = self.navigationController
            {
                temporaryNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            }
            
            self.userLocation = CLLocation(latitude: (placemark?.location?.coordinate.latitude)!, longitude: (placemark?.location?.coordinate.longitude)!)
        }
    }
    func alertMessage(message:String,buttonText:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title: "Location", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toCheckIn") {
            if let destination = segue.destination as? CheckInViewController {
                
                destination.restaurant = sender as! Restaurant
                
                
            }
        }
    }
    
    func callSegueFromCell(myData: Int) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        
        self.performSegue(withIdentifier: "toCheckIn", sender: restaurantAr[myData] )
        
    }
    
    /*func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        
        // remove separators from cells
        tableView.separatorStyle = .none
        
        self.refreshControl.addTarget(self, action: #selector(reloadTimeLine), for : .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        
    }*/

    

}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rest = restaurantAr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadarTableViewCell") as! RadarTableViewCell
        
        cell.index = indexPath.section
        
        cell.nameLabel.text = rest.name
        cell.delegate = self
        let x = rest.miles / 5280
        let y = Double(round(100*x)/100)
        cell.distanceLabel.text = "\(y) mi"
            cell.checkedPeople.text = "25 people here"
        if let url = URL(string: rest.image_url){
            cell.placeImage.kf.setImage(with: url)
        }
        cell.selectionStyle = .none

        
            return cell
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print(posts.count)
        //MARK: - Potential error
        
        return self.restaurantAr.count
    
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return RadarTableViewCell.height
    }
}



  
