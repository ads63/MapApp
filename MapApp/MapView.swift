//
//  MapView.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 24.10.2022.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var lineCoordinates: [Location]
    @Binding var avatar: UIImage

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        if lineCoordinates.count > 1 {
            let polyline = MKPolyline(coordinates: lineCoordinates.map { $0.coordinate }, count: lineCoordinates.count)
            mapView.addOverlay(polyline)
        }

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let overlays = view.overlays
        let annotations = view.annotations
        if !annotations.isEmpty {
            view.removeAnnotations(annotations)
        }

        if !overlays.isEmpty {
            view.removeOverlays(overlays)
        }
        view.setRegion(region, animated: true)
        if lineCoordinates.count > 1 {
            let polyline = MKPolyline(coordinates: lineCoordinates.map { $0.coordinate }, count: lineCoordinates.count)
            view.addOverlay(polyline)
        }
        if let lastCoordinates = lineCoordinates.last {
            let annotation = LandmarkAnnotation(coordinate: lastCoordinates.coordinate)
            view.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "avatarView")
        annotationView.image = parent.avatar
        annotationView.layer.cornerRadius = parent.avatar.size.width / 2.0
        annotationView.clipsToBounds = true
        annotationView.layer.borderWidth = 1
        annotationView.layer.borderColor = UIColor.white.cgColor
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}
