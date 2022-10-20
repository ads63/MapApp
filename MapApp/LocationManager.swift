//
//  LocationManager.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 19.10.2022.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private static let coordinateDelta = 0.1
    private let locationManager = CLLocationManager()
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Location.defaultLocation.latitude, longitude: Location.defaultLocation.longitude), span: MKCoordinateSpan(latitudeDelta: LocationManager.coordinateDelta, longitudeDelta: LocationManager.coordinateDelta))
    @Published private(set) var locations: [Location] = []
    @Published var locationStatus: CLAuthorizationStatus?
    var lastLocation: Location?
    var centerLocation: Location {
        guard let lastLocation = lastLocation else { return Location.defaultLocation }
        return lastLocation
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = Location(id: UUID(), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if !self.locations.contains(where: { $0 == centerLocation }) {
            self.locations.append(centerLocation)
        }
        if !mapRegion.center.longitude.isEqual(to: centerLocation.longitude) ||
            !mapRegion.center.latitude.isEqual(to: centerLocation.latitude)
        {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLocation.latitude, longitude: centerLocation.longitude), span: MKCoordinateSpan(latitudeDelta: LocationManager.coordinateDelta, longitudeDelta: LocationManager.coordinateDelta))
        }

        print(#function, location)
    }
}
