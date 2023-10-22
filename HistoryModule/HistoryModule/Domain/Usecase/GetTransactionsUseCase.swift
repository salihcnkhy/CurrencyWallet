//
//  GetTransactionsUseCase.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import Foundation
import Combine

public struct GetTransactionResponse {
    let transactions: [Transaction]
}

public protocol GetTransactionsUseCaseProtocol {
    func execute() -> AnyPublisher<GetTransactionResponse, Error>
}

struct MockGetTransactionsUseCase: GetTransactionsUseCaseProtocol {
    func execute() -> AnyPublisher<GetTransactionResponse, Error> {
        return Just(GetTransactionResponse(transactions: [
        ]))
        .tryMap{ $0 }
        .delay(for: 3, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

public struct GetTransactionsUseCase: GetTransactionsUseCaseProtocol {
    
    private let repository: TransactionRepositoryProtocol
    
    public init(repository: TransactionRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> AnyPublisher<GetTransactionResponse, Error> {
        repository.getTransactions()
            .map { transactions in
                GetTransactionResponse(
                    transactions: self.mapDTO(transactions: transactions)
                )
        }.eraseToAnyPublisher()
    }
    
    private func mapDTO(transactions: [TransactionDTO]) -> [Transaction] {
        transactions
            .map { dto -> Transaction? in
                let transactionType = TransactionType(rawValue: dto.type)
                let currencyType = CurrencyType(rawValue: dto.currencyCode)
                guard let currencyType, let transactionType = transactionType else {
                    return nil
                }
                
               return Transaction(
                    id: dto.id,
                    amount: dto.amount,
                    currencyRate: dto.currencyRate,
                    currencyInformation: CurrencyPropertyFactory().create(with: currencyType),
                    date: dto.date,
                    type: transactionType
                )
            }
            .compactMap { $0 }
            .sorted { first, second in
                first.date > second.date
            }
    }
}
