//
//  CurrencyListView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

struct CurrencyListView: View {
    let currencies: [Currency]
    let onBuyButtonPressed: (Currency) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            LocalizedText(key: .currencyTypesTitle)
                .font(.subheadline.bold())
                .foregroundStyle(.clPrimary)
            
            ForEach(currencies) { currency in
                CurrencyRowView(currency: currency, onBuyButtonPressed: {
                    onBuyButtonPressed(currency)
                })
            }
        }
    }
}

#Preview {
    CurrencyListView(currencies: CurrencyType.allCases.map { Currency(information: CurrencyPropertyFactory().create(with: $0), rate: Double.random(in: 20..<30), trend: Int.random(in: 0...1) == 0 ? .down : .up) }, onBuyButtonPressed: { _ in })
}
