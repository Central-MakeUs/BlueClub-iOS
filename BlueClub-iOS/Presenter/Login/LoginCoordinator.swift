//
//  LoginCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import Utility
import Navigator

final class LoginCoordinator: Coordinatorable {
    
    var navigator: Navigator?
    var child: (any Coordinatorable)?
    weak var parent: (any Coordinatorable)?

    func start(parent: (any Coordinatorable)?) {
        self.parent = parent
        navigator = .init(navigationController: .default)
        self.send(.initialLogin)
    }
}

extension LoginCoordinator {

    enum Action: Equatable {
        
        case dismiss
        case initialLogin
        case signup
    }
    
    func reduce(_ action: Action) {
        switch action {
            
        case .dismiss:
            navigator?.dismiss()
            
        case .initialLogin:
            let store = SignUpEntryView.Store(initialState: .init()) {
                SignUpEntry(coordinator: self)
            }
            navigator?.start { SignUpEntryView(store: store) }
            
        case .signup:
            let store = SignUpView.Store(initialState: .init()) {
                SignUpView.Reducer(cooridonator: self)
            }
            navigator?.push { SignUpView(store: store) }
        }
    }
}
