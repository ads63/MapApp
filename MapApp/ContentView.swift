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
    @State private var showLoadAlert = false

    var body: some View {
        ZStack {
            MapView(region: $locationManager.mapRegion, lineCoordinates: $locationManager.locations)
                .ignoresSafeArea()
            VStack {
                StyledButton(title: "Display former track", action: {
                    if locationManager.isTrackingOn {
                        showLoadAlert = true
                    } else {
                        locationManager.loadTrack()
                    }

                })
                Spacer()

                HStack {
                    StyledButton(title: "Start track", action: {
                        locationManager.startTracking()
                    })
                    StyledButton(title: "Finish track", action: {
                        locationManager.finishAndSaveTracking()
                    })
                }
                .padding(.bottom, 10)
            }
        }
        .alert(isPresented: $showLoadAlert) {
            Alert(title: Text("Warning"),
                  message: Text("Location tracking will be terminated"),
                  dismissButton: .default(Text("Ok")) {
                      locationManager.finishTracking()
                      locationManager.loadTrack()
                  })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
