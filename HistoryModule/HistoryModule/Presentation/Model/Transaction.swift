//
//  Transaction.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation
import SwiftUI

public struct Transaction: Identifiable {
    public let id: String
    let amount: Double
    let currencyRate: Double
    let currencyInformation: CurrencyInformation
    let date: Date
    let type: TransactionType
}

public enum TransactionType: String {
    case buy
    case sell
}

public enum CurrencyType: CaseIterable {
    case tl
    case usd
    case euro
    case pound
    case rub
    case cny
    
    init?(rawValue: String) {
        switch rawValue {
        case "TRY":
            self = .tl
        case "USD":
            self = .usd
        case "EUR":
            self = .euro
        case "GBP":
            self = .pound
        case "RUB":
            self = .rub
        case "CNY":
            self = .cny
        default:
            return nil
        }
    }
}

public struct CurrencyInformation {
    public let flagIcon: Image
    public let name: String
    public let sign: Sign
    public let code: String
    
    public struct Sign {
        let position: Position
        let value: String
        
        enum Position {
            case left
            case right
        }
    }
}

struct CurrencyPropertyFactory {
    func create(with type: CurrencyType) -> CurrencyInformation {
        switch type {
        case .tl:
            CurrencyInformation(
                flagIcon: .init(.icFlagTurkey),
                name: "tl",
                sign: .init(position: .right, value: "₺"),
                code: "TRY")
        case .usd:
            CurrencyInformation(
                flagIcon: .init(.icFlagUnitedStates),
                name: "dollar",
                sign: .init(position: .left, value: "$"),
                code: "USD")
        case .euro:
            CurrencyInformation(
                flagIcon: .init(.icFlagEuropeanUnion),
                name: "euro",
                sign: .init(position: .left, value: "€"),
                code: "EUR")
        case .pound:
            CurrencyInformation(
                flagIcon: .init(.icFlagUnitedKingdom),
                name: "pound",
                sign: .init(position: .left, value: "£"),
                code: "GBP")
        case .rub:
            CurrencyInformation(
                flagIcon: .init(.icFlagRussia),
                name: "rub",
                sign: .init(position: .right, value: "₽"),
                code: "RUB")
        case .cny:
            CurrencyInformation(
                flagIcon: .init(.icFlagChina),
                name: "cny",
                sign: .init(position: .right, value: "¥"),
                code: "CNY")
        }
    }
}
