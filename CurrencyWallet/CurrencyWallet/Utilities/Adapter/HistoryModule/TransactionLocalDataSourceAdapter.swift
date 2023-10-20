//
//  TransactionLocalDataSourceAdapter.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import HistoryModule
import Combine

struct TransactionLocalDataSourceAdapter: TransactionLocalDataSourceAdapterProtocol {
    
    private let realmManager: RealmManagerProtocol
    
    init(realmManager: RealmManagerProtocol) {
        self.realmManager = realmManager
    }
    
    func getTransactions() -> AnyPublisher<[HistoryModule.TransactionDTO], Error> {
        guard let results = realmManager.read(ofType: TransactionRecordObject.self) else {
            return Fail(error: NSError(domain: "", code: 0)).eraseToAnyPublisher()
        }
        
        return results
            .collectionPublisher
            .map({ results -> [TransactionDTO] in
                results.map {
                    TransactionDTO(
                        id: $0.id,
                        amount: $0.amount,
                        currencyRate: $0.currencyRate,
                        currencyCode: $0.currencyCode,
                        date: $0.date,
                        type: $0.type
                    )
                }
            })
            .eraseToAnyPublisher()
    }
}
