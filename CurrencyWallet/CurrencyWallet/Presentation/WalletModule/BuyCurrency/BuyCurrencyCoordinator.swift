//
//  BuyCurrencyCoordinator.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import PresentationLayer
import WalletModule
import SwiftUI
import UIKit

final class BuyCurrencyCoordinator: Coordinator<BuyCurrencyViewModel>, UISheetPresentationControllerDelegate {
    override func makeView() -> AnyView {
        AnyView(BuyCurrencyView(
            viewModel: viewModel,
            onCompleted: { [weak self] in
                self?.viewController?.dismiss(animated: true)
                self?.dismiss()
            }))
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismiss()
    }
}
