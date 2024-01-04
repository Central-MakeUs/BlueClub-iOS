//
//  AppCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

final class AppCoordinator {
    
    var window: UIWindow?
    
    func start(_ scene: UIWindowScene) {
        
        // 로그인 한 경우
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.rootViewController = UIHostingController(rootView: MainTabView())
        window?.makeKeyAndVisible()
    }
}
