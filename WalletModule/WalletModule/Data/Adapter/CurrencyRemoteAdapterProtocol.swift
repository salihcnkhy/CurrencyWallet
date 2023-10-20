//
//  CurrencyRemoteAdapterProtocol.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Combine

public protocol CurrencyRemoteAdapterProtocol {
    func syncCurrencies(request: GetCurrencyRequest) -> AnyPublisher<CurrencyListDTO, Error>
}
