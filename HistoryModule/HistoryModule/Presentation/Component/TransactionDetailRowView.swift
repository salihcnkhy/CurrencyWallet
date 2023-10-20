//
//  TransactionDetailRowView.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import SwiftUI

struct TransactionDetailRowView: View {
    
    let transaction: Transaction
    
    var body: some View {
        HStack {
            transaction.currencyInformation.flagIcon
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 0) {
                LocalizedText(key: .currency(transaction.currencyInformation.name))
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Group {
                    let rate = getFormatted(amount: transaction.currencyRate, sign: .init(position: .right, value: "₺"))
                    let key = transaction.type == .buy ? LocalizedKeys.purchasePrice(rate): LocalizedKeys.sellingPrice(rate)
                    LocalizedText(key: key)
                    Text(formatDate(transaction.date))
                }
                .font(.caption)
               
                .foregroundStyle(.gray)
            }
            Spacer()
            
            let amount = getFormatted(amount: transaction.amount, sign: transaction.currencyInformation.sign)
            Text(amount)
                .font(.title2.bold())
                .foregroundStyle(transaction.type == .buy ? .green : .red)
        }
    }
    
    private func getFormatted(amount: Double, sign: CurrencyInformation.Sign) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let formattedAmount = formatter.string(from: NSNumber(value: transaction.amount)) ?? ""
        var balanceWithSign = formattedAmount
        balanceWithSign.insert(contentsOf: sign.value, at: sign.position == .left ? formattedAmount.startIndex: formattedAmount.endIndex)
        
        return balanceWithSign
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

#Preview {
    TransactionDetailRowView(transaction: Transaction(id: "123", amount: 123, currencyRate: 32, currencyInformation: CurrencyPropertyFactory().create(with: .usd), date: Date(), type: .buy))
}
