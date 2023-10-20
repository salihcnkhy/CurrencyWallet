//
//  Router.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//
import UIKit

public protocol RouterProtocol {
    func setOwner(coordinator: CoordinatorProtocol)
    func push(_ type: CoordinatorRepresentable)
    func present(_ type: CoordinatorRepresentable, presentation style: UIModalPresentationStyle)
    func presentSheet(_ type: CoordinatorRepresentable, configure: (UISheetPresentationController) -> Void)
    func dismiss()
    func pop()
}

public protocol RootRouterProtocol {
    func setOwner(coordinator: RootCoordinator)
    func setRoot(_ type: CoordinatorProtocol)
}
