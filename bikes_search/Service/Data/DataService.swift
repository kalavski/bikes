//
//  DataService.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 11/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

public protocol DataServiceProtocol {
    static func fetchData<T: Decodable>(from url: URL, type: T.Type, _ completion: @escaping ((T) -> Void))
}

struct DataService: DataServiceProtocol {
    
    static let shared = DataService()
    
    static func fetchData<T: Decodable>(from url: URL, type: T.Type, _ completion: @escaping ((T) -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let x: T = DataDecoder.decodeJsonData(data: data)
            completion(x)
        }
        task.resume()
    }
}

struct DataDecoder {
    static func decodeJsonData<T: Decodable>(data: Data) -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.isoFormat)
            let values = try decoder.decode(T.self, from: data)
            return values
        } catch {
            print("\(error)")
            fatalError()
        }
    }
}
