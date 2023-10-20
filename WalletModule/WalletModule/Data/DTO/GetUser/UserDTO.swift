//
//  UserDTO.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import Foundation

public struct UserDTO {
    public let fullName: String
    public let wallets: [VirtualWalletDTO]
    
    public init(fullName: String, wallets: [VirtualWalletDTO]) {
        self.fullName = fullName
        self.wallets = wallets
    }
}

public struct VirtualWalletDTO {
    public let id: String
    public let currencyCode: String
    public let balance: Double
    
    public init(id: String, currencyCode: String, balance: Double) {
        self.id = id
        self.currencyCode = currencyCode
        self.balance = balance
    }
}
