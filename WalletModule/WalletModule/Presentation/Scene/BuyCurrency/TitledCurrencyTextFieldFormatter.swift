//
//  TitledCurrencyTextFieldFormatter.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 22.10.2023.
//

import Foundation

struct TitledCurrencyTextFieldFormatter: TitledCurrencyTextFieldFormatterProtocol {
    private let maxCharacter = 12
    
    func formatInput(with newValue: String, and oldValue: String, isFocused: Bool) -> String {
        let isBackSpace = newValue.count < oldValue.count
        var maxChars = maxCharacter
        
        var input = newValue.filter { "0123456789,".contains($0) }
        
        if  input.last == "," &&
                input.filter({ ",".contains($0) }).count > 1 {
            input.removeLast()
            return input
        }
        
        if input.count == 1 &&  input.last == "0" {
            input.removeLast()
        }
        
        var components = input.split(separator: ",")
        let componentCount = components.count
        
        guard componentCount <= 2 else {
            return ""
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
        
        if input.count > maxChars && isFocused && !isBackSpace {
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
            return input
        }
        
        guard var formattedString = formatter.string(from: number) else {
            return input
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
        
        return formattedString
    }
}
