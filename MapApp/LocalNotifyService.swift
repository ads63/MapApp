//
//  LocalNotifyService.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 21.11.2022.
//

import SwiftUI

final class LocalNotifyService {
    static func addNotification() {
        let secondsToDelay = 30 * 60 // 30 min
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: makeNotificationContent(),
                                            trigger: makeIntervalNotificatioTrigger(delay: secondsToDelay))
        UNUserNotificationCenter.current().add(request)
    }

    static func requestAuthorization() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    private static func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "We are waiting for you back"
        content.subtitle = "We miss you"
        content.body = "Thank you for using our app"
        content.badge = 1
        content.sound = UNNotificationSound.default
        return content
    }

    private static func makeIntervalNotificatioTrigger(delay: Int = 5) -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
    }
}
