//
//  GetWalletUseCase.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import Combine

public struct GetWalletResponse {
    let user: User
}

struct User {
    let fullName: String
    let wallets: [VirtualWallet]
}

public struct VirtualWallet: Identifiable, Equatable {
    public let id: String
    let currencyCode: String
    let balance: Double
}

public protocol GetUserInformationUseCaseProtocol {
    func execute() -> AnyPublisher<GetWalletResponse, Error>
    // TODO: Buraya geçici olarak yazıldı
    func subscibeWalletUpdates() -> AnyPublisher<VirtualWallet, Never>
}

struct MockGetUserInformationUseCase: GetUserInformationUseCaseProtocol {
    func subscibeWalletUpdates() -> AnyPublisher<VirtualWallet, Never> {
        return PassthroughSubject<VirtualWallet, Never>().eraseToAnyPublisher()
    }
    
    func execute() -> AnyPublisher<GetWalletResponse, Error> {
        Future { promise in
            let wallets = [
                VirtualWallet(id: "123123128", currencyCode: "TRY", balance: 5000),
                VirtualWallet(id: "123123123", currencyCode: "USD", balance: 50),
                VirtualWallet(id: "123123131", currencyCode: "EUR", balance: 150),
                VirtualWallet(id: "123123127", currencyCode: "GBP", balance: 250)
            ]
            let user = User(fullName: "Salihcan Kahya", wallets: wallets)
            let response = GetWalletResponse(user: user)
            promise(.success(response))
        }.eraseToAnyPublisher()
    }
}

public final class GetUserInformationUseCase: GetUserInformationUseCaseProtocol {
    private let repository: WalletRepository
    
    public init(repository: WalletRepository) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<GetWalletResponse, Error> {
        repository.getUserInformation()
            .map { dto in
                let virtualWallet = dto.wallets.map { VirtualWallet(id: $0.id, currencyCode: $0.currencyCode, balance: $0.balance) }
                return GetWalletResponse(user: .init(fullName: dto.fullName, wallets: virtualWallet))
            }
            .eraseToAnyPublisher()
    }
    
    public func subscibeWalletUpdates() -> AnyPublisher<VirtualWallet, Never> {
        repository.syncWallet()
            .map { VirtualWallet(id: $0.id, currencyCode: $0.currencyCode, balance: $0.balance) }
            .eraseToAnyPublisher()
    }
}
