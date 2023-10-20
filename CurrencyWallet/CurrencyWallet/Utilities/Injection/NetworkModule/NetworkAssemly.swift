//
//  NetworkAssemly.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwinjectAutoregistration
import Swinject
import NetworkModule

struct NetworkAssemly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(NetworkManagerProtocol.self, factory: { resolver in
            let interceptor = resolver.resolve(RequestInterceptor.self)!
            return NetworkManager(configuration: .default, interceptor: interceptor)
        }).inObjectScope(.container)
        
        container.autoregister(HttpPropertyProviderProtocol.self, name: "Currency", initializer: CurrencyHttpPropertyProvider.init).inObjectScope(.container)
        container.autoregister(RequestInterceptor.self, initializer: CurrencyApiInterceptor.init)
        container.register(GetCurrencyServiceProvider.self, factory: { resolver, request in
            let httpPropertyProvider = resolver.resolve(HttpPropertyProviderProtocol.self, name: "Currency")!
            return GetCurrencyServiceProvider(httpPropertyProvider: httpPropertyProvider, request: request)
        }).inObjectScope(.transient)
    }
}
