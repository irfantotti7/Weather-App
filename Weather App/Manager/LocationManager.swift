//
//  LocationManager.swift
//  Weather App
//
//  Created by Irfan T on 04/12/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get location: \(error.localizedDescription)"
    }
}

