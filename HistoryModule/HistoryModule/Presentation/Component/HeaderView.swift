//
//  HeaderView.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 20.10.2023.
//

import SwiftUI

struct HeaderView: View {
    let titleKey: LocalizedKeys
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundColor(.white)
            .frame(height: 60)
            .overlay {
                HStack {
                    LocalizedText(key: titleKey)
                        .font(.title2)
                        .padding(15)
                    Spacer()
                }
            }
        Rectangle().fill(.gray)
            .frame(height: 0.5)
    }
}

#Preview {
    HeaderView(titleKey: .transactionHistory)
}
