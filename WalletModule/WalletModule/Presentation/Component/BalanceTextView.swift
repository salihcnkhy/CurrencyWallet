//
//  BalanceTextView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 19.10.2023.
//

import SwiftUI

struct BalanceTextView: View {
    
    let code: String
    let balance: Double
    
    var body: some View {
        Text(getFormatterBalance())
            .font(.largeTitle)
    }
    
    func getFormatterBalance() -> String {
        guard let currencyType = CurrencyType(rawValue: code) else {
            return ""
        }
        
        let sign = CurrencyPropertyFactory().create(with: currencyType).sign
        
        let formatterBalance = NumberFormatter.moduleFormatter.string(from: NSNumber(value: balance)) ?? ""
        var balanceWithSign = formatterBalance
        
        balanceWithSign.insert(contentsOf: sign.value, at: sign.position == .left ? formatterBalance.startIndex: formatterBalance.endIndex)
        
        return balanceWithSign
    }
}

#Preview {
    BalanceTextView(code: "USD", balance: 1000)
}
