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

    var scene: UIWindowScene?
    var window: UIWindow?
    
    var navigator: Navigator? = .none
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
        case mainTab
    }
    
    func reduce(_ action: Action) {
        switch action {
            
        case .start(let scene):
            window = UIWindow(frame: scene.coordinateSpace.bounds)
            window?.windowScene = scene
            let view = SplashView(coordinator: self).viewController()
            window?.rootViewController = view
            window?.makeKeyAndVisible()

        case .login:
            child = LoginCoordinator()
            child?.start(parent: self)
            window?.rootViewController = child?.navigator?.view
            
        case .mainTab:
            break
            
        }
    }
}
