//
//  LocationManager.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 19.10.2022.
//

import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private static let minDelta: Double = 0.01
    private static let mapPadding = 1.1

    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Location.defaultLocation.latitude, longitude: Location.defaultLocation.longitude), span: MKCoordinateSpan(latitudeDelta: LocationManager.minDelta, longitudeDelta: LocationManager.minDelta))
    @Published var locations: [Location] = []
    @Published var locationStatus: CLAuthorizationStatus?
    private var lastLocation: Location?
    private var centerLocation: Location {
        guard let lastLocation = lastLocation else { return Location.defaultLocation }
        return lastLocation
    }

    private(set) var isTrackingOn = false
    private let locationManager = CLLocationManager()
    private let realmService = RealmService()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
        realmService.deletePointsAll()
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

    func startTracking() {
        if !isTrackingOn, [.authorizedAlways, .authorizedWhenInUse].contains(where: { $0 == locationStatus }) {
            isTrackingOn = true
            locations.removeAll()
            locationManager.startUpdatingLocation()
            guard let location = locationManager.location else { return }
            lastLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }

    func finishAndSaveTracking() {
        finishTracking()
        saveTrack()
    }

    func finishTracking() {
        isTrackingOn = false
        locationManager.stopUpdatingLocation()
    }

    func saveTrack() {
        let points = locations.enumerated().map { Point(id: $0, latitude: $1.latitude, longitude: $1.longitude) }
        realmService.insertPoints(points: points)
    }

    func loadTrack() {
        guard let points = realmService.selectPoints() else {
            return
        }
        if !points.isEmpty {
            locations.removeAll()
            locations.append(contentsOf: points.sorted(by: { $0.index < $1.index }).map { Location(latitude: $0.latitude, longitude: $0.longitude) })
            lastLocation = locations.last
            mapRegion.center = CLLocationCoordinate2D(latitude: centerLocation.latitude, longitude: centerLocation.longitude)
            mapRegion.span = getMKCoordinateSpan()
        }
    }

    private func getMKCoordinateSpan() -> MKCoordinateSpan {
        if locations.count <= 1 {
            return MKCoordinateSpan(latitudeDelta: Self.minDelta, longitudeDelta: Self.minDelta)
        }
        var calculatedDelta = LocationManager.mapPadding * 2.0 * max(
            abs((locations.map { $0.longitude }.max() ?? 180.0) - centerLocation.longitude),
            abs(centerLocation.longitude - (locations.map { $0.longitude }.min() ?? -180.0)),
            abs((locations.map { $0.latitude }.max() ?? 90.0) - centerLocation.latitude),
            abs(centerLocation.latitude - (locations.map { $0.latitude }.min() ?? -90.0)))
        if calculatedDelta.isLess(than: Self.minDelta) {
            calculatedDelta = Self.minDelta
        }
        return MKCoordinateSpan(latitudeDelta: calculatedDelta, longitudeDelta: calculatedDelta)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isTrackingOn { return }
        guard let location = locations.last else { return }
        lastLocation = Location(id: UUID(), latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if centerLocation != Location.defaultLocation {
            self.locations.append(centerLocation)
        }
        mapRegion.center = CLLocationCoordinate2D(latitude: centerLocation.latitude, longitude: centerLocation.longitude)
        mapRegion.span = getMKCoordinateSpan()
        print(#function, location)
    }
}
