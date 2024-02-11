//
//  AppCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import Navigator
import Architecture
import DesignSystem

final class AppCoordinator: Coordinatorable {
    var window: UIWindow?
    
    var navigator: Navigator = {
        let nController = UINavigationController()
        nController.setNavigationBarHidden(true, animated: true)
        return .init(navigationController: nController)
    }()
    
    private var mainTab: MainTabView {
        .init(navigator: self.navigator)
    }
}


extension AppCoordinator {
    
    enum Action: Equatable {
        case start(UIWindowScene)
        case login
        case initialSetting
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
            let viewModel = LoginViewModel(coordinator: self)
            navigator.start { LoginView(viewModel: viewModel) }
            window?.rootViewController = navigator.view
            
        case .initialSetting:
            let viewModel = InitialSettingViewModel(cooridonator: self)
            navigator.push {
                InitialSettingView(viewModel: viewModel)
            }
            break
            
        case .home:
            navigator.start { mainTab }
            window?.rootViewController = navigator.view
        }
    }
}
