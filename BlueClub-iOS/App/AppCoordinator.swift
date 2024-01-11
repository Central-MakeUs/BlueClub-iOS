//
//  AppCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import Navigator
import Architecture

final class AppCoordinator: Coordinatorable {
    var window: UIWindow?
    
    var navigator: Navigator? = {
        let nController = UINavigationController()
        nController.setNavigationBarHidden(true, animated: true)
        return .init(navigationController: nController)
    }()
    
    var child: (any Coordinatorable)? = .none
    weak var parent: (any Coordinatorable)? = .none
    
    func start(parent: (any Coordinatorable)?) {
        self.parent = parent
    }
}


extension AppCoordinator {
    
    enum Action: Equatable {
        case start(UIWindowScene)
        case login
        case signup
        case home
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .start(let scene):
            window = UIWindow(frame: scene.coordinateSpace.bounds)
            window?.windowScene = scene
            let view = SplashView(coordinator: self).viewController()
            window?.rootViewController = view
            window?.makeKeyAndVisible()

        case .login:
            let store = LoginView.Store(initialState: .init()) {
                Login(coordinator: self, dependencies: .live)
            }
            navigator?.start { LoginView(store: store) }
            window?.rootViewController = navigator?.view
            
        case .signup:
            let store = SignUpView.Store(initialState: .init()) {
                SignUp(cooridonator: self)
            }
            navigator?.push { SignUpView(store: store) }
            
        case .home:
            let store = MainTabView.Store(initialState: .init()) {
                MainTab()
            }
            navigator?.start { MainTabView(store: store) }
            window?.rootViewController = navigator?.view
        }
    }
}
