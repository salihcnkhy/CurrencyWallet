//
//  UserLocalAdapterProtocol.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import Combine

public protocol UserLocalAdapterProtocol {
    func getUserInformations() -> AnyPublisher<UserDTO, Error>
    func buyCurrency(currencyAmount: Double, liraAmount: Double, for walletId: String, completion: @escaping () -> Void)
    func onWalletUpdate() -> AnyPublisher<VirtualWalletDTO, Never> // TODO: Burada değil de başka bir yerde olması daha mantıklı olurdu
    func appendTurkishLira(amount:Double)
}
