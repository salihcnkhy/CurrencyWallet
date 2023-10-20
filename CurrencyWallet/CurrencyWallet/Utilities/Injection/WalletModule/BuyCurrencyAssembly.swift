//
//  BuyCurrencyAssembly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwinjectAutoregistration
import Swinject
import WalletModule

struct BuyCurrencyAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(BuyCurrencyCoordinator.self, factory: { (resolver, currency: Currency) in
            let viewModel = resolver.resolve(BuyCurrencyViewModel.self, argument: currency)!
            return BuyCurrencyCoordinator(viewModel: viewModel)
        }).inObjectScope(.transient)
        
        container.register(BuyCurrencyViewModel.self) { (resolver, currency: Currency) in
            let buyCurrencyUseCase = resolver.resolve(BuyCurrencyUseCaseProtocol.self)!
            return BuyCurrencyViewModel(currency: currency, buyCurrencyUseCase: buyCurrencyUseCase)
        }.inObjectScope(.transient)
        
        container.autoregister(BuyCurrencyUseCaseProtocol.self, initializer: BuyCurrencyUseCase.init)
    }
}
