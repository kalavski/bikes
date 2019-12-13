//
//  MyFeedsViewController.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 11/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import UIKit
import CoreLocation

class MyFeedsViewController: UITableViewController {
    
    static let path: String = Source.URL.path
    private var locations: [Location] = []
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setTableViewConfig()
    }
    
    private func fetchData() {
        DataService.fetchData(from: URL(string: MyFeedsViewController.path)!, type: Items.self) {[weak self] (items) in
            guard let self = self else { return }
            self.locations = items.locations
            
            for index in 0..<self.locations.count {
                let center = CLLocation(latitude: self.locations[index].geometry.coordinates[1], longitude: self.locations[index].geometry.coordinates[0])
                let geoCoder = CLGeocoder()
                geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
                    guard let self = self else { return }
                    guard let placemark = placemarks?.first else { return }
                    let streetName: String = placemark.thoroughfare ?? ""
                    let city: String = placemark.subLocality ?? ""
                    self.locations[index].address = "\(streetName), \(city)"
                }
            }
            self.locationManager.delegate = self
            self.checkLocationServices()
        }
    }
    
    private func setTableViewConfig() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
    }
    
    public func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show an alert
        }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}

extension MyFeedsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.className, for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        cell.location = locations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  DetailsViewController.className) as? DetailsViewController else { return }
        vc.location = self.locations[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
}

extension MyFeedsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = locations.last else { return }
        for index in 0..<self.locations.count {
            self.locations[index].distance = clLocation.distance(from: CLLocation(latitude: self.locations[index].geometry.coordinates[1], longitude: self.locations[index].geometry.coordinates[0]))
        }
        self.locations.sort { (location1, location2) -> Bool in
            location1.distance ?? 0 < location2.distance ?? 0
        }
        updateUI { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}
