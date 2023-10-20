//
//  BaseCoordinator.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation
import UIKit
import SwiftUI

open class RoutableCoordinator<V, R>: Coordinator<V> {
    public let router: R
    
    public init(viewModel: V, router: R) {
        self.router = router
        super.init(viewModel: viewModel)
        prepareRouter()
    }
    
    private func prepareRouter() {
        (router as? RouterProtocol)?.setOwner(coordinator: self)
    }
}

open class Coordinator<V>: NSObject, CoordinatorProtocol {
    public var viewController: UIViewController?
    public let id: UUID = .init()
    public weak var parent: CoordinatorProtocol?
    public var isPresenting: Bool = false
    private var childs: [CoordinatorProtocol] = []
    public let viewModel: V
    
    public init(viewModel: V) {
        self.viewModel = viewModel
        super.init()
        print("Coordinator started \(self)")
    }
    
    public func start() -> UIViewController {
        let view = makeView()
        let viewController = HostingViewController(content: view, dismiss: handleDismiss)
        self.viewController = viewController
        return viewController
    }
    
    public func start(coordinator: CoordinatorProtocol) -> UIViewController {
        childs.append(coordinator)
        coordinator.parent = self
        let viewController = coordinator.start()
        return viewController
    }
    
    public func dismiss() {
        removeChilds()
        parent?.removeChild(self)
    }
    
    open func makeView() -> AnyView {
        fatalError()
    }
    
    private lazy var handleDismiss: () -> Void = { [weak self] in
        self?.dismiss()
    }
    
    public func removeChilds() {
        let childArray = childs
        
        childArray.forEach { child in
            child.dismiss()
        }
        
        childs = []
    }
    
    public func removeChild(_ coordinator: CoordinatorProtocol) {
        guard let index = childs.firstIndex(where: { coordinator.id == $0.id }) else { return }
        childs.remove(at: index)
    }
    
    deinit {
        print("DEINIT \(NSStringFromClass(self.classForCoder).split(separator: ".")[1])")
    }
}
