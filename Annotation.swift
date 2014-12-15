//
//  UneAnnotation.swift
//  iSouvenir
//
//  Created by m2sar on 26/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

//MKAnnotation
class Annotation : NSObject,MKAnnotation {
    
    //internal var coordinate: CLLocationCoordinate2D
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var image : UIImage!
    var haveImage : Bool
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.haveImage = false

    }
    
    
   
    
}
