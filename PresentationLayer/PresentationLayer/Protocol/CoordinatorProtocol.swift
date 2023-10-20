//
//  Coordinator.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation
import UIKit

public protocol CoordinatorProtocol: AnyObject {
    var id: UUID { get }
    func removeChild(_ coordinator: CoordinatorProtocol)
    var viewController: UIViewController? { get set }
    var parent: CoordinatorProtocol? { get set }
    func start() -> UIViewController
    func start(coordinator: CoordinatorProtocol) -> UIViewController
    func dismiss()
}

public protocol RootCoordinator: AnyObject, CoordinatorProtocol {
    func setRoot(_ coordinator: CoordinatorProtocol)
    func setWindow(_ window: UIWindow)
    func appStart()
}
