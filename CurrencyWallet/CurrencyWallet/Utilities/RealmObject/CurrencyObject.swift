//
//  CurrencyObject.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import RealmSwift
import Foundation

final class CurrencyObject: Object {
    @Persisted(wrappedValue: "currency", primaryKey: true) var id: String
    @Persisted var currencies: List<CurrencyItemObject>
    @Persisted var updateDate: Date
    
    convenience init(currencies: [CurrencyItemObject], updateDate: Date) {
        self.init()
        self.currencies = List()
        self.updateDate = updateDate
        
        self.currencies.append(objectsIn: currencies)
    }
}
