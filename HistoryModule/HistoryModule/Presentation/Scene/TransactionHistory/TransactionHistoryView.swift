//
//  TransactionHistoryView.swift
//  HistoryModule
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import SwiftUI

public struct TransactionHistoryView: View {
    @ObservedObject private var viewModel: TransactionHistoryViewModel
    
    public init(viewModel: TransactionHistoryViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            HeaderView(titleKey: .transactionHistory)

            if viewModel.isFetching {
                ProgressView {
                    LocalizedText(key: .loading)
                        .font(.callout)
                }
                .frame(maxHeight: .infinity)
            } else {
                if viewModel.transactions.isEmpty {
                    VStack {
                        Image(.icSadFace)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 45, height: 45)
                            .foregroundStyle(.clPrimary)

                        LocalizedText(key: .noTransactionYet)
                            .font(.callout)
                            .foregroundStyle(.clPrimary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        TransationDetailListView(transactions: viewModel.transactions)
                            .padding(.top, 10)
                            .padding(.horizontal, 15)
                    }
                }
            }
        }
        
        .onAppear {
            viewModel.fetchTransactions()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(.clBackground)
    }
}

#Preview {
    TransactionHistoryView(viewModel: .init(getTransactionsUseCase: MockGetTransactionsUseCase()))
}
