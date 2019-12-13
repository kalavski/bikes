//
//  FeedCell.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 11/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import UIKit
import CoreLocation

class FeedCell: UITableViewCell {
    @IBOutlet weak var card: Card!
    
    var reloadAddressCallback: (() -> Void)?
    var location: Location? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        card.placeLabel.text = location?.properties.label
        card.availableBikesCountLabel.text = String(location!.properties.bikes)
        card.availablePlacesCountLabel.text = String(location!.properties.freeRacks)
        card.distanceLabel.text = Distance.distance(location!.distance ?? 0).info
        card.addressLabel.text = location!.address
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
