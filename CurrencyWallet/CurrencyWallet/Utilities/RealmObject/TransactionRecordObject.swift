//
//  TransactionRecordObject.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import RealmSwift
import Foundation

final class TransactionRecordObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var amount: Double
    @Persisted var currencyRate: Double
    @Persisted var currencyCode: String
    @Persisted var date: Date
    @Persisted var type: String
    
    convenience init(id: String, amount: Double, currencyRate: Double, currencyCode: String, date: Date, type: String) {
        self.init()
        self.id = id
        self.amount = amount
        self.currencyRate = currencyRate
        self.currencyCode = currencyCode
        self.date = date
        self.type = type
    }
}
