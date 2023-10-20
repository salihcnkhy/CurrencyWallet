//
//  LocalizedText.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import SwiftUI

struct LocalizedText: View {
    
    let key: LocalizedKeys
    
    var body: some View {
        Text(key.localized, bundle: .historyModule)
    }
}


#Preview {
    LocalizedText(key: .currency("USD"))
}
