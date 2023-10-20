//
//  TransactionLocalDataSourceAdapterProtocol.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Combine

public protocol TransactionLocalDataSourceAdapterProtocol {
    func getTransactions() -> AnyPublisher<[TransactionDTO], Error>
}
