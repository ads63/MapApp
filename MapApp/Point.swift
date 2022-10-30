//
//  Point.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 28.10.2022.
//

import CoreLocation
import Foundation
import RealmSwift

final class Point: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var index: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    convenience init(id: Int, latitude: Double, longitude: Double) {
        self.init()
        self.index = id
        self.latitude = latitude
        self.longitude = longitude
    }
}
