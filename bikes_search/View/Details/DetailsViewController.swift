//
//  DetailsViewController.swift
//  bikes_search
//
//  Created by Przemysław Kalawski on 11/12/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var location: Location!
    private let locationManager: CLLocationManager = CLLocationManager()
    private final let regionInMeters: Double = 10000
    
    @IBOutlet weak var mkMapView: MKMapView!
    @IBOutlet weak var cardView: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mkMapView.delegate = self
        
        setViews()
        addMarker()
        locationManager.delegate = self
        checkLocationServices()
    }
    
    private func setViews() {
        cardView.placeLabel.text = location.properties.label
        cardView.availableBikesCountLabel.text = "\(location.properties.bikeRacks)"
        cardView.availablePlacesCountLabel.text = "\(location.properties.freeRacks)"
        cardView.addressLabel.text = location.address
    }
    
    private func addMarker() {
        let coord = CLLocationCoordinate2D(latitude: location.geometry.coordinates[1], longitude: location.geometry.coordinates[0])
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coord, span: span)
        let mkPointAnnotation: MKAnnotation = BikeAnnotation(coord.latitude, coord.longitude)
        self.mkMapView.region = region
        self.mkMapView.addAnnotation(mkPointAnnotation)
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? BikeAnnotation else { return nil }
        let annotationView = MKMarkerAnnotationView()
        annotationView.annotation = annotation
        annotationView.markerTintColor = .white
        annotationView.glyphImage = #imageLiteral(resourceName: "bike")
        return annotationView
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
            mkMapView.showsUserLocation = true
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

extension DetailsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateUI { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cardView.distanceLabel.text = Distance.distance(location.distance(from: CLLocation(latitude: strongSelf.location.geometry.coordinates[1], longitude: strongSelf.location.geometry.coordinates[0]))).info
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}
