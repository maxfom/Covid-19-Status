//
//  MapViewController.swift
//  Covid-19-Status
//
//  Created by Георгий Сабанов on 24.08.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.layer.cornerRadius = 22
            locationButton.layer.masksToBounds = true
        }
    }
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        } else {
            zoomToLocation()
        }
    }
    
    @IBAction func locationAction() {
        zoomToLocation()
    }
    
    private func getUserLocation() -> CLLocationCoordinate2D? {
        manager.requestLocation()
        return manager.location?.coordinate
    }
    
    private func zoomToLocation() {
        guard let location = getUserLocation() else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse else { return }
        zoomToLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("new locations", locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
}
