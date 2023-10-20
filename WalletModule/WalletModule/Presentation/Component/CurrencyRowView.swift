//
//  CurrencyRowView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

struct CurrencyRowView: View {
    let currency: Currency
    let onBuyButtonPressed: () -> Void
    
    var body: some View {
        HStack {
            currency.information.flagIcon
                .resizable()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                LocalizedText(key: .currency(currency.information.name))
                CurrencyTrendView(currency: currency)
                    .font(.callout.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedButtonView(title: .buy) {
                onBuyButtonPressed()
            }
            .frame(width: 100, height: 50)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CurrencyRowView(currency: .init(information: CurrencyPropertyFactory().create(with: .usd), rate: 23.234, trend: .up), onBuyButtonPressed: { }).padding()
}
