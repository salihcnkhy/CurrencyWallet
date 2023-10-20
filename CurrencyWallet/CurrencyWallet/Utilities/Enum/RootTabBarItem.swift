//
//  RootTabBarItem.swift
//  CurrencyWallet
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import UIKit
import PresentationLayer

enum RootTabBarItem: Int, CaseIterable {
    case home
    case history
    
    func getTabBar() -> TabBar {
        switch self {
        case .home:
            let title = String(localized: .init(stringLiteral: "tab_home_title"), bundle: .main)
            return TabBar(coordinator: Coordinators.home.coordinator, title: title,  icon: .icHome.withRenderingMode(.alwaysTemplate))
        case .history:
            let title = String(localized: .init(stringLiteral: "tab_history_title"), bundle: .main)
            return TabBar(coordinator: Coordinators.history.coordinator, title: title,  icon: .icHistory.withRenderingMode(.alwaysTemplate))
        }
    }
    
    struct TabBar {
        let coordinator: CoordinatorProtocol
        let title: String
        let icon: UIImage?
    }
}
