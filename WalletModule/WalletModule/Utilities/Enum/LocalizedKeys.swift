//
//  LocalizedKeys.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import SwiftUI

enum LocalizedKeys {
    case greeting(String)
    case walletId(String)
    case addMoney
    case transactionHistory
    case buy
    case currencyTypesTitle
    case currencyAmountWouldLikeToBuyTitle(String)
    case totalAmountOfCurrencyAsTL
    case currency(String)
    case updateTime(String)
    case transactionCompleted
    case copyDone
    case notEnoughLiraBalance
    case noAvailableWallet
    case generalError
    
    var localized: LocalizedStringKey {
        switch self {
        case .greeting(let name):
            "greeting \(name)"
        case .walletId(let string):
            "wallet_id: \(string)"
        case .addMoney:
            "add_money"
        case .transactionHistory:
            "transaction_history"
        case .buy:
            "buy"
        case .currencyTypesTitle:
            "currency_types_title"
        case .currencyAmountWouldLikeToBuyTitle(let currencyName):
            "currency_amount_want_to_buy \(currencyName)"
        case .totalAmountOfCurrencyAsTL:
            "total_amount_currency_as_tl"
        case .currency(let name):
            LocalizedStringKey(String("currency_"+name))
        case .updateTime(let date):
            "updateTime: \(date)"
        case .transactionCompleted:
            "transaction_completed"
        case .copyDone:
            "copy_done"
        case .notEnoughLiraBalance:
            "not_enought_lira"
        case .noAvailableWallet:
            "you_dont_have_wallet"
        case .generalError:
            "general_error"
        }
    }
}
