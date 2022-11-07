//
//  RealmService.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 28.10.2022.
//

import Foundation
import RealmSwift

final class RealmService {
    static let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    func dropDB() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func selectUser(login: String) -> Results<User>? {
        var data: Results<User>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            data = realm.objects(User.self).where { $0.login == login }
        } catch {
            print(error)
        }
        return data
    }

    func insertUser(user: User) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            deletePointsAll()
            realm.beginWrite()
            realm.add(user, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func selectPoints() -> Results<Point>? {
        var data: Results<Point>?
        do {
            let realm = try Realm(configuration: RealmService.config)
            data = realm.objects(Point.self)
        } catch {
            print(error)
        }
        return data
    }

    func insertPoints(points: [Point]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            deletePointsAll()
            realm.beginWrite()
            realm.add(points, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deletePoints(points: [Point]) {
        do {
            let realm = try Realm(configuration: RealmService.config)
            realm.beginWrite()
            realm.delete(points)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    func deletePointsAll() {
        do {
            let realm = try Realm(configuration: RealmService.config)
            deletePoints(points: [Point](realm.objects(Point.self)))
        } catch {
            print(error)
        }
    }
}
