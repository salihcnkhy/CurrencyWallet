//
//  LocalAssemly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Swinject
import SwinjectAutoregistration

struct LocalAssemly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(RealmManagerProtocol.self, initializer: RealmManager.init).inObjectScope(.container)
        container.autoregister(UserLocalDataSourceProtocol.self, initializer: UserLocalDataSourceManager.init).inObjectScope(.container)
    }
}
