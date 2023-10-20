//
//  CurrencyTrendView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import SwiftUI

struct CurrencyTrendView: View {
    let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    private var icon: Image {
        currency.trend == .up ?
        Image(systemName: "arrow.up"):
        Image(systemName: "arrow.down")
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            let color: Color = currency.trend == .up ? .green : .red
            
            Text(convertRateToString())
                .lineLimit(1)
                .foregroundStyle(color)
            
            icon
                .foregroundStyle(color)
                
        }
    }
    
    private func convertRateToString() -> String {
        let formatted = NumberFormatter
            .moduleFormatter
            .string(from: currency.rate as NSNumber) ?? "0.00"
        
        return String(format: "%@%@", formatted, "₺")
    }
}

#Preview {
    Group {
        CurrencyTrendView(currency: .init(information: CurrencyPropertyFactory().create(with: .usd), rate: 27.095, trend: .down))
            .font(.largeTitle)
        
        CurrencyTrendView(currency: .init(information: CurrencyPropertyFactory().create(with: .usd), rate: 27.09, trend: .up))
    }
}
