//
//  User.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 03.11.2022.
//
import CoreLocation
import Foundation
import RealmSwift
import UIKit

final class User: Object {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String

    convenience init(login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
