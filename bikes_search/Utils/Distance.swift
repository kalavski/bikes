//
//  Distance.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 13/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

enum Distance {
    case distance(Double)
    
    var info: String {
        switch self {
        case .distance(let distance):
            if distance < 1000 {
                return String(round(distance)) + " m"
            } else {
                return String(round(distance / 1000)) + " km"
            }
        }
    }
}
