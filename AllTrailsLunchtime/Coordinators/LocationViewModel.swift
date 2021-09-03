//
//  LocationViewModel.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//

import UIKit
import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject {
    @Published var currentLatitude: Double? = nil
    @Published var currentLongitude: Double? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private let locationManager = CLLocationManager()

    private var isFirstTime = true
    
    override init() {
        super.init()
        requestPermission()
    }
    
    private func requestPermission() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            default:
                // .restricted and .denied are handled in ContextView.
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This function is called continuously and it causes ContentView to refresh non-stop.
        // User can not do anything in the map because of that.
        // So set current values only for the first time.
        guard let locValue = manager.location?.coordinate,
              isFirstTime else {
            return
        }
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        isFirstTime = false
    }
}
