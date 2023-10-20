//
//  TransactionDTO.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation

public struct TransactionDTO {
    let id: String
    let amount: Double
    let currencyRate: Double
    let currencyCode: String
    let date: Date
    let type: String
    
    public init(id: String, amount: Double, currencyRate: Double, currencyCode: String, date: Date, type: String) {
        self.id = id
        self.amount = amount
        self.currencyRate = currencyRate
        self.currencyCode = currencyCode
        self.date = date
        self.type = type
    }
}
