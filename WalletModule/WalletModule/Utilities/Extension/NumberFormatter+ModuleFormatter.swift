//
//  NumberFormatter+Default.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import Foundation

extension NumberFormatter {
    static let moduleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
}
