//
//  LandmarkAnnotation.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 05.12.2022.
//
import MapKit

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String? = nil,
         subtitle: String? = nil,
         coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
