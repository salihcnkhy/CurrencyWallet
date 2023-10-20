//
//  RootAssembly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Swinject
import SwinjectAutoregistration
import PresentationLayer

struct RootAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(RootCoordinator.self, initializer: RootCoordinator.init).inObjectScope(.container)
        container.autoregister(RootViewModel.self, initializer: RootViewModel.init).inObjectScope(.container)
        container.autoregister(RootRouter.self, initializer: RootRouter.init).inObjectScope(.container)
    }
}
