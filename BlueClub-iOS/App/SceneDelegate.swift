//
//  SceneDelegate.swift
//  BlueClub-iOS

//  Created by 김인섭 on 1/3/24.
//

import SwiftUI
import DependencyContainer
import DataSource
import Domain
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let coordinator = AppCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        coordinator.send(.start(scene))
        configDependencies()
        configDesignSystem()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // 카카오 로그인 하면 여기로 열림
        // kakaoc54841ca9f7d5edce0ad7244305b9c8c://oauth?code=I8lj1oamAGIp0UXO6IHr_Mf-fPAu7rQoEu-OMHnbgG4rT0nQrqSsell4AX4KPXTaAAABjQFE0U8h5oEAb4_jFQ
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                 _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}

private extension SceneDelegate {
    
    func configDesignSystem() {
        UIFont.registerFonts()
    }
    
    func configDependencies() {
        
        // NOTE: - DataSouce
        Container.live
            .register { AppleLoginService() as AppleLoginServiceable }
            .register { UserRepository(dependencies: .live) as UserServiceable }
            .register { DateService() as DateServiceable }
    }
}

extension Container {
    
    static let live = Container()
}
