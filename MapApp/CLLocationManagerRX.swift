//
//  CLLocationManagerRX.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 12.11.2022.
//

import CoreLocation
import Foundation
import RxSwift

final class CLLocationManagerRX: NSObject {
    let locationManager = CLLocationManager()
    let location: PublishSubject<CLLocation?> = PublishSubject()
    let locationStatus: PublishSubject<CLAuthorizationStatus?> = PublishSubject()

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    override init() {
        super.init()
        configureLocationManager()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
}

extension CLLocationManagerRX: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus.onNext(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.onNext(locations.last)
    }
}
