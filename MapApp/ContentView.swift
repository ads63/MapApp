//
//  ContentView.swift
//  MapKitApp
//
//  Created by Алексей Шинкарев on 17.10.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var showMapView: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $showMapView,
                               destination: { MainView(showMapView: $showMapView) },
                               label: { EmptyView() })
                LoginView(showMapView: $showMapView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
