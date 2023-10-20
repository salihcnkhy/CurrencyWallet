//
//  RootCoordinator.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation
import PresentationLayer
import SwiftUI
import UIKit

final class RootCoordinator: BaseRootCoordinator<RootViewModel, RootRouter> {
    override func start() -> UIViewController {
        let tabBarController = UITabBarController()
        
        RootTabBarItem
            .allCases
            .map { $0.getTabBar() }
            .enumerated()
            .forEach { index, tabbar in
                let coordinator = tabbar.coordinator
                let viewController = start(coordinator: coordinator)
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.tabBarItem = .init(title: tabbar.title, image: tabbar.icon, tag: index)
                tabBarController.addChild(navigationController)
            }
        
        return tabBarController
    }
}
