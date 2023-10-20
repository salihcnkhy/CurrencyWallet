//
//  HomeCoordinator.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import PresentationLayer
import WalletModule
import SwiftUI

final class HomeCoordinator: RoutableCoordinator<HomeViewModel, HomeRouter> {
    override func makeView() -> AnyView {
        AnyView(
            HomeView(
                viewModel: viewModel,
                routeCallback: { [weak self] route in
                    self?.router.handleRoute(route)
                })
        )
    }
}

