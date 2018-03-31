//
//  MKPointAnnotation.swift
//  RADAR
//
//  Created by Rosalia Dupont on 7/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}

