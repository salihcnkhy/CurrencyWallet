//
//  LocalizedText.swift
//  WalletModule
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import SwiftUI

struct LocalizedText: View {
    
    let key: LocalizedKeys
    
    var body: some View {
        Text(key.localized, bundle: .walletModule)
    }
}

#Preview {
    LocalizedText(key: .walletId("123"))
}
