//
//  TransationDetailListView.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import SwiftUI

struct TransationDetailListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .center) {
            ForEach(transactions) { transaction in
                TransactionDetailRowView(transaction: transaction)
            }
        }
    }
}

#Preview {
    Group {
        TransationDetailListView(transactions: [
            Transaction(id: UUID().uuidString, amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .usd), date: Date(), type: .buy),
            Transaction(id: UUID().uuidString, amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .cny), date: Date(), type: .sell),
            Transaction(id: UUID().uuidString, amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .euro), date: Date(), type: .buy),
            Transaction(id: UUID().uuidString, amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .pound), date: Date(), type: .buy),
            Transaction(id: UUID().uuidString, amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .pound), date: Date(), type: .sell)
            
        ])
    }
}
