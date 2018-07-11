//
//  RealmHelper.swift
//  ESV
//
//  Created by Kushal Ashok on 1/10/18.
//

import Foundation
import RealmSwift

let realmHelper = RealmHelper.shared

protocol RealmObject {
    func save()
    func update()
}
extension RealmObject {
    func save() {
        if let object = self as? Object {
            realmHelper.writeToRealm {realmHelper.realm().add(object)}
        }
    }
    func update() {
        if let object = self as? Object {
            realmHelper.writeToRealm {realmHelper.realm().add(object, update: true)}
        }
    }
}

class RealmHelper: NSObject {
    static let shared: RealmHelper = RealmHelper()
    
    // path for realm file
    lazy private var realmURL: URL = {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("default.realm")
        print("\n\nRealm file is located at: \n\(url)\n")
        return url
    }()
    lazy private var config:Realm.Configuration = {
        return Realm.Configuration(
            fileURL: self.realmURL,
            inMemoryIdentifier: nil,
            encryptionKey:nil, //"my65bitkey".data(using: String.Encoding.utf8),
            readOnly: false,
            schemaVersion: 1,
            migrationBlock: nil,
            deleteRealmIfMigrationNeeded: false,
            objectTypes: nil)
    }()
    
    /// Method used to remove the Realm database files when there are any configuration changes
    func clearRealmFiles() {
        let documentUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = documentUrl.appendingPathComponent("default.realm")
        let lockFile = documentUrl.appendingPathComponent("default.realm.lock")
        let managerFolder = documentUrl.appendingPathComponent("default.realm.management")
        do {
            try FileManager.default.removeItem(at: url)
            try FileManager.default.removeItem(at: lockFile)
            try FileManager.default.removeItem(at: managerFolder)
        }
        catch{
            print(error)
        }
    }
    
    func inMemoryRealm() -> Realm? {
        do {
            let realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            return realm
        } catch {
            do {
                let realm = try Realm(configuration: config)
                return realm
            }catch{
                print(error)
            }
            print(error)
        }
        return try! Realm()
    }
    
    func realm() -> Realm {
        do {
            // Get the default Realm
            let realm = try Realm(configuration: config)
            return realm
        } catch {
            self.clearRealmFiles()
            do {
                let realm = try Realm(configuration: config)
                return realm
            }catch{
                print(error)
            }
            print(error)
        }
        return try! Realm()
    }
    func writeToRealm(_ closure: () -> Void) {
        do {
            try realm().write {
                closure()
            }
        } catch {
            print(error)
        }
    }
    func getObjects<T: Object>(_ type: T.Type, filterString: String?) -> Results<T>? {
        if let filter = filterString {
            return realm().objects(type).filter(filter)
        } else {
            return realm().objects(type)
        }
    }
    func getObjects<T: Object>(_ type: T.Type, valueForKey key: String?) -> Any? {
        if let keyString = key {
            return realm().objects(type).value(forKey: keyString)
        } else {
            return realm().objects(type)
        }
    }
    func deleteObjects<T: Object>(_ type: T.Type, filterString: String?) {
        var objects: Results<T>?
        if let filter = filterString {
            objects  = realm().objects(type).filter(filter)
        } else {
            objects  = realm().objects(type)
        }
        guard let objectsToBeDeleted = objects else {return}
        writeToRealm {realm().delete(objectsToBeDeleted)}
    }
    func deleteAll() {
        writeToRealm {realm().deleteAll()}
    }

}
