//
//  Coordinators.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import PresentationLayer
import WalletModule

enum Coordinators {
    case home
    case buyCurrency(Currency)
    case history
}

extension Coordinators: CoordinatorRepresentable, GetResolver {
    var coordinator: CoordinatorProtocol {
        switch self {
        case .home:
            returnResolver().resolve(HomeCoordinator.self)!
        case .buyCurrency(let currency):
            returnResolver().resolve(BuyCurrencyCoordinator.self, argument: currency)!
        case .history:
            returnResolver().resolve(TransactionHistoryCoordinator.self)!
        }
    }
}
