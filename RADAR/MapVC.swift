//
//  MapVC.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class MapVC: UIViewController {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.pinTintColor = .blue
        return annotationView
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
        var latDelta:CLLocationDegrees = 0.01
    
        var longDelta:CLLocationDegrees = 0.01
    
        override func viewDidLoad() {
        super.viewDidLoad()

            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.5635293, -122.3249982)
    
            let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
            mapView.setRegion(region, animated: true)
    
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.5635293, -122.3249982)
            let objectAnnotation = MKPointAnnotation()
    
            
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "my location"
            self.mapView.addAnnotation(objectAnnotation)
    }
}

    
    /*let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
    
    
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


