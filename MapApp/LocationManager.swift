//
//  LocationManager.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 19.10.2022.
//

import CoreLocation
import Foundation
import MapKit
import RxSwift

class LocationManager: NSObject, ObservableObject {
    private static let minDelta: Double = 0.01
    private static let mapPadding = 1.1

    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Location.defaultLocation.latitude, longitude: Location.defaultLocation.longitude), span: MKCoordinateSpan(latitudeDelta: LocationManager.minDelta, longitudeDelta: LocationManager.minDelta))
    @Published var locations: [Location] = []
    private var locationStatus: CLAuthorizationStatus?
    private var lastLocation: Location?
    private var centerLocation: Location {
        guard let lastLocation = lastLocation else { return Location.defaultLocation }
        return lastLocation
    }

    private(set) var isTrackingOn = false
    private let locationManager = CLLocationManagerRX()
    private let realmService = RealmService()
    private let disposeBag = DisposeBag()
    private var locationDisposable: Disposable?
    private var locationStatusDisposable: Disposable?

    override init() {
        super.init()
        locationStatusDisposable = locationManager.locationStatus.bind(onNext: { [weak self] newStatus in
            self?.locationStatus = newStatus
        })
        locationDisposable = locationManager.location.bind(onNext: {
            [weak self] newLocation in
            guard let self = self,
                  self.isTrackingOn,
                  let newLocation = newLocation
            else { return }
            self.lastLocation = Location(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
            if self.centerLocation != Location.defaultLocation {
                self.locations.append(self.centerLocation)
            }
            self.mapRegion.center = CLLocationCoordinate2D(latitude: self.centerLocation.latitude, longitude: self.centerLocation.longitude)
            self.mapRegion.span = self.getMKCoordinateSpan()

        })
        realmService.deletePointsAll()
    }

    deinit {
        locationDisposable?.disposed(by: disposeBag)
        locationStatusDisposable?.disposed(by: disposeBag)
    }


    func startTracking() {
        if !isTrackingOn, [.authorizedAlways, .authorizedWhenInUse].contains(where: { $0 == locationStatus }) {
            isTrackingOn = true
            locations.removeAll()
            locationManager.startUpdatingLocation()
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
        var calculatedDelta = LocationManager.mapPadding * 2.2 * max(
            abs((locations.map { $0.longitude }.max() ?? 180.0) - centerLocation.longitude),
            abs(centerLocation.longitude - (locations.map { $0.longitude }.min() ?? -180.0)),
            abs((locations.map { $0.latitude }.max() ?? 90.0) - centerLocation.latitude),
            abs(centerLocation.latitude - (locations.map { $0.latitude }.min() ?? -90.0)))
        if calculatedDelta.isLess(than: Self.minDelta) {
            calculatedDelta = Self.minDelta
        }
        return MKCoordinateSpan(latitudeDelta: calculatedDelta, longitudeDelta: calculatedDelta)
    }
}
