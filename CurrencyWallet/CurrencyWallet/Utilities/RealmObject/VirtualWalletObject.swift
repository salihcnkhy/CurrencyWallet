//
//  VirtualWalletObject.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import RealmSwift

final class VirtualWalletObject: Object {
    @Persisted var id: String
    @Persisted(primaryKey: true) var currencyCode: String
    @Persisted var balance: Double
    
    convenience init(id: String, currencyCode: String, balance: Double) {
        self.init()
        self.id = id
        self.currencyCode = currencyCode
        self.balance = balance
    }
}
