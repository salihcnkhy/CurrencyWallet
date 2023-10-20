//
//  AppendTurkishLiraUseCase.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import Foundation

public protocol AppendTurkishLiraUseCaseProtocol {
    func appendTurkishLira()
}

struct MockAppendTurkishLiraUseCase: AppendTurkishLiraUseCaseProtocol {
    func appendTurkishLira() {
        print("MockAppendTurkishLiraUseCase")
    }
}

public struct AppendTurkishLiraUseCase: AppendTurkishLiraUseCaseProtocol {
    private let repository: WalletRepository
    
    public init(repository: WalletRepository) {
        self.repository = repository
    }
    
    public func appendTurkishLira() {
        let amount = Double.random(in: 1000...10000)
        repository.appendTurkishLira(amount: amount)
    }
}
