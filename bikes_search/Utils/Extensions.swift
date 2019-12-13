//
//  Extensions.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 12/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

func updateUI(_ completion: @escaping (() -> Void)) {
    DispatchQueue.main.async {
        completion()
    }
}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
