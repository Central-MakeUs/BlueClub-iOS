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
import Lottie
import Utility

struct SplashView: View {
    
    // MARK: - Depedenceis
    weak var coordinator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(coordinator: AppCoordinator, dependencies: Container = .live) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            LottieView(animation: .named("splash"))
                .playing(loopMode: .loop)
                .frame(width: 147, height: 147)
            Image("blueclub", bundle: .main)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.colors(.primaryNormal))
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let user = userRepository.getLoginUser()
            guard user != nil else {
                coordinator?.send(.login)
                return
            }
            coordinator?.send(.home)
        }
        .onAppear { printLog() }
    }
}

#Preview {
    SplashView(coordinator: .init(), dependencies: .live)
}
