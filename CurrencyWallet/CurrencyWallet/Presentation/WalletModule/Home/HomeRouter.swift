//
//  HomeRouter.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 17.10.2023.
//

import Foundation
import PresentationLayer
import WalletModule
import UIKit

final class HomeRouter: Router<HomeRoute> {
    private let tabbarRouter: TabBarRouterProtocol
    
    init(tabbarRouter: TabBarRouterProtocol) {
        self.tabbarRouter = tabbarRouter
    }
    
    override func handleRoute(_ route: HomeRoute) {
        switch route {
        case .buyCurrency(let currency):
            presentSheet(Coordinators.buyCurrency(currency)) { sheet in
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        case .history:
            tabbarRouter.openTab(to: .history)
        }
    }
}
