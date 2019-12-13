//
//  LocationService.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 12/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService {
    
    static let shared: LocationService = LocationService()
    public let locationManager: CLLocationManager = CLLocationManager()
}
