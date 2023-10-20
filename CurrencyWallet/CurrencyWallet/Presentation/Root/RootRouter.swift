//
//  RootRouter.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import PresentationLayer
import UIKit

protocol TabBarRouterProtocol {
    func openTab(to item: RootTabBarItem)
}

final class RootRouter: BaseRootRouter, TabBarRouterProtocol {
    func openTab(to item: RootTabBarItem) {
        guard let tabbarController = owner?.viewController as? UITabBarController else { return }
        tabbarController.selectedIndex = item.rawValue
    }
}
