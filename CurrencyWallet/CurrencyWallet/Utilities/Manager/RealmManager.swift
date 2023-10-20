//
//  RealmManager.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import RealmSwift

enum RealmWriteOperation {
    case add(Object, Realm.UpdatePolicy)
    case update(() -> Void)
}

protocol RealmManagerProtocol {
    func read<T: Object, K>(ofType type: T.Type, keyType: K) -> T?
    func read<T: Object>(ofType type: T.Type) -> Results<T>?
    func write(operation: RealmWriteOperation, completion: ((Bool) -> Void)?)
}

final class RealmManager: RealmManagerProtocol {
    private var realm: Realm?

    public init() {
        connect()
    }
    
    func connect() {
        do {
            realm = try Realm()
        } catch let error {
            print("Realm bağlantı hatası: \(error.localizedDescription)")
        }
    }

    func write(operation: RealmWriteOperation, completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            do {
                try self.realm?.write {
                    switch operation {
                    case .add(let object, let policy):
                        self.realm?.add(object, update: policy)
                    case .update(let process):
                        process()
                    }
                    
                    completion?(true)
                }
            } catch let error {
                print("Veri yazma hatası: \(error.localizedDescription)")
                completion?(false)
            }
        }
    }
    
    func read<T: Object, K>(ofType type: T.Type, keyType: K) -> T? {
        return realm?.object(ofType: T.self, forPrimaryKey: keyType)
    }
    
    func read<T: Object>(ofType type: T.Type) -> Results<T>? {
        return realm?.objects(T.self)
    }
}
