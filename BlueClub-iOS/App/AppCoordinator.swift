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
            let reducer = Login(coordinator: self)
            navigator?.start { LoginView(reducer: reducer) }
            window?.rootViewController = navigator?.view
            
        case .signup:
            let reducer = SignUp(cooridonator: self)
            navigator?.push { SignUpView(reducer: reducer) }
            
        case .home:
            navigator?.start { MainTabView(state: .init()) }
            window?.rootViewController = navigator?.view
        }
    }
}
