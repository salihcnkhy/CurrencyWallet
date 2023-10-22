//
//  UserLocalAdapter.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import WalletModule
import Combine

struct UserLocalAdapter: UserLocalAdapterProtocol {

    private let walletUpdateSubject = PassthroughSubject<VirtualWalletDTO, Never>()
    private let userLocalDataSource: UserLocalDataSourceProtocol
    
    init(userLocalDataSource: UserLocalDataSourceProtocol) {
        self.userLocalDataSource = userLocalDataSource
    }
    
    private func getUserInformationOrCreate(_ completion: @escaping (UserDTO) -> Void) {
        if let user = userLocalDataSource.getUser() {
            completion(user)
        } else {
            
            let virtualWallets: [VirtualWalletDTO] = CurrencyPropertyFactory().createAll()
                .map {
                    VirtualWalletDTO(id: String.getUniqueInt(), currencyCode: $0.code, balance: 0)
                }
            
            let userDto = UserDTO(fullName: "Salihcan Kahya", wallets: virtualWallets)
            userLocalDataSource.createUser(with: userDto, completion: {
                completion(userDto)
            })
        }
    }
    
    func getUserInformations() -> AnyPublisher<UserDTO, Error> {
        Future { promise in
            getUserInformationOrCreate { user in
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    
    func onWalletUpdate() -> AnyPublisher<VirtualWalletDTO, Never> {
        walletUpdateSubject
            .share()
            .eraseToAnyPublisher()
    }
    
    func buyCurrency(currencyAmount: Double, liraAmount: Double, for currencyCode: String, completion: @escaping (UserLocalAdapterError?) -> Void) {
        userLocalDataSource.buyCurrencyBalance(currencyAmount, liraAmount: liraAmount, for: currencyCode, completion: { result in
            switch result {
            case .success(let (otherWallet, tryWallet)):
                self.walletUpdateSubject.send(.init(id: otherWallet.id, currencyCode: otherWallet.currencyCode, balance: otherWallet.balance))
                self.walletUpdateSubject.send(.init(id: tryWallet.id, currencyCode: tryWallet.currencyCode, balance: tryWallet.balance))
                completion(nil)
            case .failure(let error):
                switch error {
                case .userNotFound:
                    completion(.userNotFound)
                case .liraAmountIsNotEnough:
                    completion(.walletBalanceNotEnough)
                }
                break
            }
        })
    }
    
    func appendTurkishLira(amount: Double) {
        userLocalDataSource.appendVirtualWalletBalance(amount, for: "TRY", completion: { virtualWallet in
            self.walletUpdateSubject.send(.init(id: virtualWallet.id, currencyCode: virtualWallet.currencyCode, balance: virtualWallet.balance))
        })
    }
}
