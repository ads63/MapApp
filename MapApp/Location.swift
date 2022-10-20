//
//  Location.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 18.10.2022.
//

import CoreLocation
import Foundation

struct Location: Identifiable, Equatable {
    var id: UUID
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static let defaultLocation = Location(id: UUID(),
                                          latitude: 55.753215, longitude: 37.622504)

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.latitude.isEqual(to: rhs.latitude) &&
            lhs.longitude.isEqual(to: rhs.longitude)
    }
}
