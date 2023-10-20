//
//  Assembler.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import Swinject

extension Assembler {
    static let shared: Assembler = {
        let assembler = Assembler()
        assembler.apply(assembly: RootAssembly())
        assembler.apply(assembly: LocalAssemly())
        assembler.apply(assembly: NetworkAssemly())
        assembler.apply(assembly: HomeAssembly())
        assembler.apply(assembly: BuyCurrencyAssembly())
        assembler.apply(assembly: TransactionHistoryAssembly())
        return assembler
    }()
}

protocol GetResolver {
    func returnResolver() -> Resolver
}

extension GetResolver {
    func returnResolver() -> Resolver {
        Assembler.shared.resolver
    }
}
