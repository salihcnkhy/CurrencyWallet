//
//  RoundedButtonView.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import SwiftUI

struct RoundedButtonView: View {
    private let title: LocalizedKeys
    private let action: () -> Void
    private let disableProvider: () -> Bool
    
    init(title: LocalizedKeys, action: @escaping () -> Void, disableProvider:  @escaping () -> Bool = { return false }) {
        self.title = title
        self.action = action
        self.disableProvider = disableProvider
    }
    
    var body: some View {
        let isDisabled = disableProvider()
        Button(action: action) {
            LocalizedText(key: title)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isDisabled ? .black.opacity(0.75): Color.clPrimary)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isDisabled)
    }
}

#Preview {
    RoundedButtonView(title: .addMoney, action: {}, disableProvider: { false })
}
