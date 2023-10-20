//
//  LocalizedKeys.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import SwiftUI

enum LocalizedKeys {
    case purchasePrice(String)
    case sellingPrice(String)
    case currency(String)
    case noTransactionYet
    case loading
    case transactionHistory
    
    var localized: LocalizedStringKey {
        switch self {
        case .purchasePrice(let price):
            "purchase_price \(price)"
        case .sellingPrice(let price):
            "selling_price \(price)"
        case .currency(let name):
            LocalizedStringKey(String("currency_"+name))
        case .noTransactionYet:
            "no_transaction_yet"
        case .loading:
            "loading"
        case .transactionHistory:
            "transaction_history"
        }
    }
}
