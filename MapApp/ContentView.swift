//
//  ContentView.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 17.10.2022.
//

import MapKit
import SwiftUI
struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Map(coordinateRegion: $locationManager.mapRegion, annotationItems: locationManager.locations) { location in
            MapMarker(coordinate: location.coordinate)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
