//
//  TransactionHistoryViewModel.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import Foundation
import Combine

public final class TransactionHistoryViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isFetching: Bool = false
    
    private let getTransactionsUseCase: GetTransactionsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(getTransactionsUseCase: GetTransactionsUseCaseProtocol) {
        self.getTransactionsUseCase = getTransactionsUseCase
    }
    
    func fetchTransactions() {
        isFetching = true
        getTransactionsUseCase
            .execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                // TODO: error handling terkar dene butonu göster
            } receiveValue: { [weak self] response in
                self?.transactions = response.transactions
                self?.isFetching = false
            }
            .store(in: &cancellables)
    }
}
