//
//  WalletRepository.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import Combine

public final class WalletRepository {
    private var cancellables: Set<AnyCancellable> = []
    private let remoteDataSource: CurrencyRemoteAdapterProtocol
    private let userLocalDataSource: UserLocalAdapterProtocol
    
    public init(remote: CurrencyRemoteAdapterProtocol, userLocalDataSource: UserLocalAdapterProtocol) {
        self.remoteDataSource = remote
        self.userLocalDataSource = userLocalDataSource
    }
    
    func getCurrencies(request: GetCurrencyRequest) -> AnyPublisher<CurrencyListDTO, Error> {
        remoteDataSource
            .syncCurrencies(request: request)
            .eraseToAnyPublisher()
    }
    
    func getUserInformation() -> AnyPublisher<UserDTO, Error> {
        userLocalDataSource
            .getUserInformations()
            .eraseToAnyPublisher()
    }
    
    func buyCurrency(currencyAmount: Double, liraAmount: Double, wallet id: String, completion: @escaping (UserLocalAdapterError?) -> Void) {
        userLocalDataSource.buyCurrency(currencyAmount: currencyAmount, liraAmount: liraAmount, for: id, completion: completion)
    }
    
    func syncWallet() -> AnyPublisher<VirtualWalletDTO, Never> {
        userLocalDataSource.onWalletUpdate()
    }
    
    func appendTurkishLira(amount: Double) {
        userLocalDataSource.appendTurkishLira(amount: amount)
    }
}
