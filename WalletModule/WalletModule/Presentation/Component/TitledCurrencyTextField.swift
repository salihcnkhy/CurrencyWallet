//
//  TitledTextField.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import SwiftUI

protocol TitledCurrencyTextFieldFormatterProtocol {
    func formatInput(with newValue: String, and oldValue: String, isFocused: Bool) -> String
}

struct TitledCurrencyTextField: View {
    let titleKey: LocalizedKeys
    let currencySign: String
    let formatter: TitledCurrencyTextFieldFormatterProtocol
    
    @Binding var input: String
    private let placeHolder = "0,00"
    @FocusState var focusState: Bool

    var body: some View {
        VStack(alignment: .leading) {
            LocalizedText(key: titleKey)
                .font(.subheadline.bold())
            
            HStack {
                TextField(placeHolder, text: $input)
                    .font(.title2)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused($focusState)
                
                Text(currencySign)
                    .font(.title)
                    .foregroundStyle(.clSecondary)
                    .frame(width: 20, height: 20)
            }
            
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 1)
                    .stroke(.gray, lineWidth: 1)
            )
            .onChange(of: input) { [input] newValue in
                formatInput(with: newValue, and: input)
            }
        }
    }
    
    func formatInput(with newValue: String, and oldValue: String) {
        self.input = formatter.formatInput(with: newValue, and: oldValue, isFocused: focusState)
    }
}

#Preview {
    TitledCurrencyTextField(titleKey: .currencyAmountWouldLikeToBuyTitle("test"), currencySign: "₺", formatter: TitledCurrencyTextFieldFormatter(), input: .constant(""), focusState: .init())
}
