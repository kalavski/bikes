//
//  Geometry.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 11/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

struct Items: Decodable {
    let locations: [Location]

    private enum CodingKeys: String, CodingKey {
        case locations = "features"
    }
}

struct Location: Identifiable, Decodable {
    let id: String
    let geometry: Geometry
    let type: String
    let properties: Properties
    
    var distance: Double?
    var address: String?
}

struct Geometry: Decodable {
    let coordinates: [Double]
    let type: String
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Properties {
    let freeRacks: Int
    let bikes: Int
    let label: String
    let bikeRacks: Int
    let updated: Date
    
    private enum CodingKeys: String, CodingKey {
        case freeRacks = "free_racks"
        case bikes
        case label
        case bikeRacks = "bike_racks"
        case updated
    }
}
extension Properties: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        freeRacks = Int(try values.decode(String.self, forKey: .freeRacks)) ?? 0
        bikes = Int(try values.decode(String.self, forKey: .bikes)) ?? 0
        label = try values.decode(String.self, forKey: .label)
        bikeRacks = Int(try values.decode(String.self, forKey: .bikeRacks)) ?? 0

        let dateString = try values.decode(String.self, forKey: .updated)
        let formatter = DateFormatter.isoFormat
        if let date = formatter.date(from: dateString) {
            updated = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updated,
                  in: values,
                  debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

extension DateFormatter {
  static let isoFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
  }()
}
