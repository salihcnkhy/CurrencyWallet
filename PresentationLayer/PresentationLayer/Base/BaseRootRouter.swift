//
//  BaseRootRouter.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation

open class BaseRootRouter: RootRouterProtocol {
    private(set) public weak var owner: RootCoordinator?
    
    public init() { }

    public func setOwner(coordinator: RootCoordinator) {
        owner = coordinator
    }
    
    public func setRoot(_ coordinator: CoordinatorProtocol) {
        guard let owner = owner else { return }
        owner.setRoot(coordinator)
    }
}
