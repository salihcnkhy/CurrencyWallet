//
//  CurrencyItemDTO.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation

public struct CurrencyItemDTO: Decodable {
    public let code: String
    public let value: Double
    
    public init(code: String, value: Double) {
        self.code = code
        self.value = value
    }
}
