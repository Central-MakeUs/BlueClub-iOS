//
//  SplashView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import DesignSystem
import DependencyContainer
import Domain

struct SplashView: View {
    
    weak var coordinator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(coordinator: AppCoordinator, dependencies: Container = .live) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image("character", bundle: .main)
            Image("blueclub", bundle: .main)
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.colors(.primaryNormal))
        .task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if userRepository.hasLogin {
                coordinator?.send(.home)
            } else {
                coordinator?.send(.login)
            }
        }
    }
}
