//
//  BaseRootCoordinator.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 16.10.2023.
//

import Foundation
import UIKit

open class BaseRootCoordinator<V, R: RootRouterProtocol>: NSObject, RootCoordinator {
    public var viewController: UIViewController?
    public var parent: CoordinatorProtocol?
    private var window: UIWindow?
    public let id: UUID = UUID()
    private var childs: [CoordinatorProtocol] = []

    private let viewModel: V
    private let router: R
    
    public init(viewModel: V, router: R) {
        self.viewModel = viewModel
        self.router = router
        super.init()
        prepareRouter()
    }
    
    private func prepareRouter() {
        router.setOwner(coordinator: self)
    }
    
    public func setWindow(_ window: UIWindow) {
        self.window = window
    }
    
    private func removeChilds() {
        childs.forEach { child in
            child.dismiss()
        }
        
        childs.removeAll()
    }
    
    public func dismiss() {
        removeChilds()
    }
    
    public func setRoot(_ coordinator: CoordinatorProtocol) {
        removeChilds()
        let viewController = start(coordinator: coordinator)
        setRoot(viewController)
    }
    
    public func setRoot(_ viewController: UIViewController) {
        self.viewController = viewController
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        window?.isUserInteractionEnabled = true
    }
    
    public func appStart() {
        let viewController = (self as CoordinatorProtocol).start()
        self.viewController = viewController
        setRoot(viewController)
    }
    
    public func start(coordinator: CoordinatorProtocol) -> UIViewController {
        childs.append(coordinator)
        coordinator.parent = self
        return coordinator.start()
    }
    
    public func removeChild(_ coordinator: CoordinatorProtocol) {
        guard let index = childs.firstIndex(where: { $0.id == coordinator.id }) else { return }
        childs.remove(at: index)
    }
    
    open func start() -> UIViewController {
       fatalError()
    }
}
