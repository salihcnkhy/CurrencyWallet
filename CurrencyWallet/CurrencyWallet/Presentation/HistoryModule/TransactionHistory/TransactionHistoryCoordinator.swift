//
//  TransactionHistoryCoordinator.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 18.10.2023.
//

import PresentationLayer
import HistoryModule
import SwiftUI

final class TransactionHistoryCoordinator: Coordinator<TransactionHistoryViewModel> {
    override func makeView() -> AnyView {
        AnyView(TransactionHistoryView(viewModel: viewModel))
    }
}
