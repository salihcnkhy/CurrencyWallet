//
//  CurrencyHttpPropertyProvider.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import NetworkModule

struct CurrencyHttpPropertyProvider: HttpPropertyProviderProtocol {
    func getBaseUrl() -> String {
        "https://api.currencyapi.com/v3/latest"
    }
}
