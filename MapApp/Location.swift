//
//  Location.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 18.10.2022.
//

import CoreLocation
import Foundation
import MapKit

struct Location: Identifiable, Equatable {
    var id: UUID
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(id: UUID = UUID(), latitude: Double?, longitude: Double?) {
        self.id = id
        self.latitude = latitude ?? Location.defaultLocation.latitude
        self.longitude = longitude ?? Location.defaultLocation.longitude
    }

    static let defaultLocation = Location(id: UUID(),
                                          latitude: 37.40169564, longitude: -122.18389160)

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.latitude.isEqual(to: rhs.latitude) &&
            lhs.longitude.isEqual(to: rhs.longitude)
    }
}
