//
//  MainView.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 03.11.2022.
//

import MapKit
import SwiftUI

struct MainView: View {
    @Binding var showMapView: Bool
    @Binding var userName: String
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel: ViewModel = .shared
    @State private var showLoadAlert = false
    @State private var showCameraView = false

    var body: some View {
        ZStack {
            MapView(region: $locationManager.mapRegion, lineCoordinates: $locationManager.locations, avatar: $viewModel.avatarImage)
                .ignoresSafeArea()
            VStack {
                HStack {
                    StyledButton(title: "Display former track", action: {
                        if locationManager.isTrackingOn {
                            showLoadAlert = true
                        } else {
                            locationManager.loadTrack()
                        }

                    })
                    StyledButton(title: "New avatar", action: {
                        showCameraView.toggle()
                    }).sheet(isPresented: $showCameraView) {
                        ImageSelectorView(viewModel: .shared)
                    }
                }
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
        .onAppear {
            viewModel.userName = self.userName
        }
        .onChange(of: self.userName) { newValue in
            viewModel.userName = newValue
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

    @ViewBuilder
    func imageView(for image: UIImage?) -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Text("No image selected")
        }
    }
}

// struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
// }
