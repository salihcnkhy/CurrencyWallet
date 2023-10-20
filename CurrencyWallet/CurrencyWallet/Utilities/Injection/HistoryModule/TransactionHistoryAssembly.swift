//
//  TransactionHistoryAssembly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwinjectAutoregistration
import Swinject
import HistoryModule

struct TransactionHistoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(TransactionHistoryCoordinator.self, initializer: TransactionHistoryCoordinator.init).inObjectScope(.transient)
        container.autoregister(TransactionHistoryViewModel.self, initializer: TransactionHistoryViewModel.init).inObjectScope(.transient)
        
        container.autoregister(GetTransactionsUseCaseProtocol.self, initializer: GetTransactionsUseCase.init).inObjectScope(.transient)
        
        
        container.autoregister(TransactionLocalDataSourceAdapterProtocol.self, initializer: TransactionLocalDataSourceAdapter.init).inObjectScope(.weak)
        container.autoregister(TransactionRepositoryProtocol.self, initializer: TransactionRepository.init).inObjectScope(.weak)
        
    }
}
