//
//  CurrencyItemObject.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import RealmSwift

final class CurrencyItemObject: Object {
    @Persisted(primaryKey: true) var code: String
    @Persisted var rate: Double
    
    convenience init(code: String, rate: Double) {
        self.init()
        self.code = code
        self.rate = rate
    }
}
