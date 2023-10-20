//
//  TitledTextField.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import SwiftUI

struct TitledCurrencyTextField: View {
    let titleKey: LocalizedKeys
    @Binding var input: String
    @FocusState var focusState: Bool
    private let maxCharacter = 12
    private let placeHolder = "0,00"
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
                Image(.icFlagChina)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: 1)
                    .stroke(.gray, lineWidth: 1)
            )
            .onChange(of: input) { [input] newValue in
                print(newValue, input)
                formatInput(with: newValue, and: input)
            }
        }
    }
    
    func formatInput(with newValue: String, and oldValue: String) {
        
        let isBackSpace = newValue.count < oldValue.count
        var maxChars = maxCharacter
        
        var input = newValue.filter { "0123456789,".contains($0) }
        
        if  input.last == "," &&
                input.filter({ ",".contains($0) }).count > 1 {
            input.removeLast()
            return
        }
        
        if input.count == 1 &&  input.last == "0" {
            input.removeLast()
        }
        
        var components = input.split(separator: ",")
        let componentCount = components.count
        
        guard componentCount <= 2 else {
            input = ""
            return
        }
        
        var itHasTwoDigitAndEndWithZero: Bool = false
        var itHasOneDigitAndEndWithZero: Bool = false
        var itHasTwoDigitAndAllWithZero: Bool = false
        if componentCount == 2 {
            if components[1].count > 2 {
                components[1].removeLast()
                input.removeLast()
            }
            
            if components[1].count == 2 {
                itHasTwoDigitAndEndWithZero = components[1].last == "0"
                itHasTwoDigitAndAllWithZero = itHasTwoDigitAndEndWithZero && components[1].first == "0"
                
            } else if components[1].count == 1 {
                itHasOneDigitAndEndWithZero = components[1].last == "0"
            }
            
            maxChars += components[1].count
        }
        
        if input.count > maxChars && focusState && !isBackSpace {
            input.removeLast()
        }
        
        var valueStr = input
        
        let isNeedsToRemoveLastComma = valueStr.last == ","
        
        if isNeedsToRemoveLastComma {
            valueStr.removeLast()
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        
        guard let number = formatter.number(from: valueStr) else {
            return
        }
        
        guard var formattedString = formatter.string(from: number) else {
            return
        }
        
        if isNeedsToRemoveLastComma {
            formattedString.append(",")
        } else if itHasOneDigitAndEndWithZero {
            formattedString.append(",0")
        } else if itHasTwoDigitAndAllWithZero {
            formattedString.append(",00")
        } else if itHasTwoDigitAndEndWithZero {
            formattedString.append("0")
        }
        
        self.input = formattedString
    }
}

#Preview {
    TitledCurrencyTextField(titleKey: .currencyAmountWouldLikeToBuyTitle("test"), input: .constant(""), focusState: .init())
}
