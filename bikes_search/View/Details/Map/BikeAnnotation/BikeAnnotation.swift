//
//  BikeAnnotation.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 13/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import MapKit

class BikeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
