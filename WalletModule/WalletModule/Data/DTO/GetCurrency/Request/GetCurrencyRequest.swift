//
//  GetCurrencyRequest.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation

public struct GetCurrencyRequest: Encodable {
    let currencies: [String]
    let baseCurrency: String = "TRY"
    
    init(currencies: [String]) {
        self.currencies = currencies
    }
    
    enum CodingKeys: String, CodingKey {
        case currencies
        case baseCurrency = "base_currency"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let currencyStr = currencies.joined(separator: ",")
        try container.encode(currencyStr, forKey: .currencies)
        try container.encode(baseCurrency, forKey: .baseCurrency)
    }
}
