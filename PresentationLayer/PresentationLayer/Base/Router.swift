//
//  BaseRouter.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation
import UIKit

open class Router<Route>: NSObject, RouterProtocol {
    private weak var owner: CoordinatorProtocol?
    
    public override init() { }
    
    public func setOwner(coordinator: CoordinatorProtocol) {
        owner = coordinator
    }
    
    public func push(_ type: CoordinatorRepresentable) {
        guard let owner = owner else { return }
        
        let destinationCoordinator = type.coordinator
        let viewController = owner.start(coordinator: destinationCoordinator)
        
        owner.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func present(_ type: CoordinatorRepresentable, presentation style: UIModalPresentationStyle) {
        guard let owner = owner else { return }
        
        let destinationCoordinator = type.coordinator
        let viewController = owner.start(coordinator: destinationCoordinator)
 
        let presentingNavigationController = UINavigationController(rootViewController: viewController)
        presentingNavigationController.modalPresentationStyle = style
        
        owner.viewController?.navigationController?.present(presentingNavigationController, animated: true)
    }
    
    public func presentSheet(_ type: CoordinatorRepresentable, configure: (UISheetPresentationController) -> Void) {
        guard let owner = owner else { return }
        
        let destinationCoordinator = type.coordinator
        let viewController = owner.start(coordinator: destinationCoordinator)

        let presentingNavigationController = UINavigationController(rootViewController: viewController)
        
        if let sheet = presentingNavigationController.sheetPresentationController {
            configure(sheet)
            if let delegate = destinationCoordinator as? UISheetPresentationControllerDelegate {
                sheet.delegate = delegate
            }
        }
        
        owner.viewController?.navigationController?.present(presentingNavigationController, animated: true)
    }
    
    public func dismiss() {
        guard let owner = owner else { return }
        owner.dismiss()
        owner.viewController?.navigationController?.dismiss(animated: true)
    }
    
    public func pop() {
        guard let owner = owner else { return }
        owner.dismiss()
        owner.viewController?.navigationController?.popViewController(animated: true)
    }
    
    open func handleRoute(_ route: Route) { }
    
    deinit {
        print("DEINIT \(NSStringFromClass(self.classForCoder).split(separator: ".")[1])")
    }
}
