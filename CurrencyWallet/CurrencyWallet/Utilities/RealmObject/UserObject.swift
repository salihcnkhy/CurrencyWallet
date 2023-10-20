//
//  UserObject.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import RealmSwift

final class UserObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var fullName: String
    @Persisted var wallets: List<VirtualWalletObject>
    
    convenience init(id: String, fullName: String, wallets: [VirtualWalletObject]) {
        self.init()
        self.id = id
        self.fullName = fullName
        self.wallets = List()
        self.wallets.append(objectsIn: wallets)
    }
}
