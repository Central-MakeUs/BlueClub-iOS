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
        guard let scene else { return }
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        self.send(.splash)
        window?.makeKeyAndVisible()
    }
}


extension AppCoordinator {
    
    enum Action: Equatable {
        case splash
        case login
        case mainTab
    }
    
    func reduce(_ action: Action) {
        switch action {
            
        case .splash:
            window?.rootViewController = SplashView(coordinator: self).viewController()
            
        case .login:
            child = LoginCoordinator()
            child?.start(parent: self)
            window?.rootViewController = child?.navigator?.view
            
        case .mainTab:
            break
            
        }
    }
}
