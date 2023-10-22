//
//  UserLocalDataSourceManager.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation
import WalletModule


enum UserLocalDataSourceError: Error {
    case userNotFound
    case liraAmountIsNotEnough
}

protocol UserLocalDataSourceProtocol {
    func appendVirtualWalletBalance(_ balance: Double, for id: String, completion: @escaping (VirtualWalletObject) -> Void)
    func buyCurrencyBalance(_ balance: Double, liraAmount: Double, for id: String, completion: @escaping (Result<(VirtualWalletObject, VirtualWalletObject), UserLocalDataSourceError>) -> Void)
    func getUser() -> UserDTO?
    func createUser(with user: UserDTO, completion: @escaping () -> Void)
}

final class UserLocalDataSourceManager: UserLocalDataSourceProtocol {
    private let realmManager: RealmManagerProtocol
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    func appendVirtualWalletBalance(_ balance: Double, for currencyCode: String, completion: @escaping (VirtualWalletObject) -> Void) {
        guard let virtualWalletObject = realmManager.read(ofType: VirtualWalletObject.self, keyType: currencyCode) else { return }
        
        realmManager.write(operation: .update({
            virtualWalletObject.balance += balance
        }), completion: { isSuccess in
            guard isSuccess else { return }
            completion(virtualWalletObject)
        })
    }
    
    func buyCurrencyBalance(_ balance: Double, liraAmount: Double, for currencyCode: String, completion: @escaping (Result<(VirtualWalletObject, VirtualWalletObject), UserLocalDataSourceError>) -> Void) {
        guard let virtualWalletObject = realmManager.read(ofType: VirtualWalletObject.self, keyType: currencyCode) else { return }
        guard let tryWalletObject = realmManager.read(ofType: VirtualWalletObject.self, keyType: "TRY") else { return }
        
        let tryBalance = tryWalletObject.balance
        guard liraAmount <= tryBalance else {
            // TODO: Bu kontrolü buraya koydum şimdilik ama BuyCurrencyUseCase'e koyulması gerekiyor.
            completion(.failure(.liraAmountIsNotEnough))
            return
        }
        
        // TODO: Burada bir rollback mekanizması olabilir
        realmManager.write(operation: .update({
            virtualWalletObject.balance += balance
            tryWalletObject.balance -= liraAmount
        }), completion: { [weak self] isSuccess in
            guard let self else { return }
            guard isSuccess else { return }
            self.createTransactionRecord(currencyAmount: balance, liraAmount: liraAmount, currencyCode: currencyCode, type: "buy") {
                completion(.success((virtualWalletObject, tryWalletObject)))
            }
        })
    }
    
    func getUser() -> WalletModule.UserDTO? {
        guard let userObject = realmManager.read(ofType: UserObject.self, keyType: "user") else { return nil }
        let virtualWallets = Array(userObject.wallets.map { VirtualWalletDTO(id: $0.id, currencyCode: $0.currencyCode, balance: $0.balance) })
        return WalletModule.UserDTO(fullName: userObject.fullName, wallets: virtualWallets)
    }
    
    func createUser(with user: UserDTO, completion: @escaping () -> Void) {
        let userObject = UserObject(id: "user", fullName: user.fullName, wallets: user.wallets.map { VirtualWalletObject(id: $0.id, currencyCode: $0.currencyCode, balance: $0.balance) })
        realmManager.write(operation: .add(userObject, .all), completion: { isSuccess in
            guard isSuccess else { return }
            completion()
        })
    }
    
    private func createTransactionRecord(currencyAmount: Double, liraAmount: Double, currencyCode: String, type: String, completion: @escaping () -> Void) {
        let record = TransactionRecordObject(
            id: UUID().uuidString,
            amount: currencyAmount,
            currencyRate: liraAmount / currencyAmount, // TODO: Rate'in burada bu şekile verilmesi çok mantıklı değil
            currencyCode: currencyCode,
            date: Date(),
            type: type
        )
        
        realmManager.write(operation: .add(record, .all), completion: { isSuccess in
            guard isSuccess else { return }
            completion()
        })
    }
}
