//
//  HostingViewController.swift
//  PresentationLayer
//
//  Created by Salihcan Kahya on 13.10.2023.
//

import Foundation
import SwiftUI

final class HostingViewController<Content>: UIHostingController<Content> where Content: View {
    
    let dismissCallback: () -> Void
    
    init(content: Content, dismiss: @escaping () -> Void) {
        self.dismissCallback = dismiss
        super.init(rootView: content)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        dismissCallback()
    }
    
    deinit {
        print("DEINIT \(NSStringFromClass(self.classForCoder))")
    }
}
