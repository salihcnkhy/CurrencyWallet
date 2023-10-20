//
//  HomeAssembly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwinjectAutoregistration
import Swinject
import WalletModule
import NetworkModule

struct HomeAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init).inObjectScope(.transient)
        container.autoregister(HomeViewModel.self, initializer: HomeViewModel.init).inObjectScope(.transient)
        container.register(HomeRouter.self, factory: { resolver in
            let rootRouter = resolver.resolve(RootRouter.self)!
            return HomeRouter(tabbarRouter: rootRouter)
        }).inObjectScope(.transient)
        
        container.autoregister(WalletRepository.self, initializer: WalletRepository.init)
        
        container.autoregister(GetCurrenciesUseCaseProtocol.self, initializer: GetCurrenciesUseCase.init)
        container.autoregister(GetUserInformationUseCaseProtocol.self, initializer: GetUserInformationUseCase.init)
        container.autoregister(AppendTurkishLiraUseCaseProtocol.self, initializer: AppendTurkishLiraUseCase.init)

        container.autoregister(CurrencyLocalStorageManagerProtocol.self, initializer: CurrencyLocalStorageManager.init).inObjectScope(.weak)
        container.autoregister(CurrencyRemoteAdapterProtocol.self, initializer: CurrencyRemoteAdapter.init).inObjectScope(.weak)
        container.autoregister(UserLocalAdapterProtocol.self, initializer: UserLocalAdapter.init).inObjectScope(.container)
        
        container.autoregister(CurrencySynchronizerProtocol.self, initializer: CurrencySynchronizer.init).inObjectScope(.container)
    }
}
