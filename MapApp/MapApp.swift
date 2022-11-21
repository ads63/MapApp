//
//  MapApp.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 20.10.2022.
//

import SwiftUI

@main
struct MapApp: App {
    let appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
