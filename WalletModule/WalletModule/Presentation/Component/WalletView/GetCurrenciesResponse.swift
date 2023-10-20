//
//  GetCurrenciesResponse.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public struct GetCurrenciesResponse {
    let currencies: [CurrencyItem]
    let updatedAt: Date
}

public struct CurrencyItem {
    let name: String
    let value: Double
}
