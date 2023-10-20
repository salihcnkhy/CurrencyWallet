//
//  TransactionRepositoryProtocol.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation
import Combine

public protocol TransactionRepositoryProtocol {
    func getTransactions() -> AnyPublisher<[TransactionDTO], Error>
}

public final class TransactionRepository: TransactionRepositoryProtocol {
    private let localDataSource: TransactionLocalDataSourceAdapterProtocol

    public init(localDataSource: TransactionLocalDataSourceAdapterProtocol) {
        self.localDataSource = localDataSource
    }
    
    public func getTransactions() -> AnyPublisher<[TransactionDTO], Error> {
        localDataSource.getTransactions()
    }
}
