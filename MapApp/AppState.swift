//
//  AppState.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 21.11.2022.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isActive: Bool?
    @Published var deactivationState = false

    private var observers = [NSObjectProtocol]()

    init() {
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) {
                _ in
                if !(self.isActive ?? true) { self.deactivationState = false }
                self.isActive = true
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                if self.isActive ?? false { self.deactivationState = true }
                self.isActive = false
            }
        )
        observers.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { _ in
                if self.isActive ?? false { self.deactivationState = true }
                self.isActive = false
            }
        )
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }
}
