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
    @State private var blurRadius = CGFloat(0.0)
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $showMapView,
                               destination: { MainView(showMapView: $showMapView) },
                               label: { EmptyView() })
                LoginView(showMapView: $showMapView)
            }
        }
        .blur(radius: blurRadius)
        .onChange(of: scenePhase) { phase in
            blurRadius = phase == .active ? CGFloat(0.0) : CGFloat(20.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
