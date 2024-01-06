//
//  SplashView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import DesignSystem

struct SplashView: View {
    
    weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
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
            let hasLogin = false
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if hasLogin {
                coordinator?.send(.mainTab)
            } else {
                coordinator?.send(.login)
            }
        }
    }
}
