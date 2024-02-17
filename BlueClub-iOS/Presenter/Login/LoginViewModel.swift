//
//  Login.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import Domain
import DependencyContainer
import Architecture
import Combine
import DataSource
import Utility

final class LoginViewModel: ObservableObject {
    
    // MARK: - Datas
    @Published var isLoading = false
    
    // MARK: - Dependencies
    weak var coordinator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    private var authApi: AuthNetworkable { dependencies.resolve() }
    
    init(coordinator: AppCoordinator, dependencies: Container = .live) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

extension LoginViewModel: Actionable {
    
    enum Action {
        case didSelectLoginMethod(LoginMethod)
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .didSelectLoginMethod(let method):
            Task {
                do {
                    self.isLoading = true
                    let user = try await self.userRepository.requestLogin(method)
                    userRepository.registLoginUser(user)
                    
                    let userInfo = try await self.authApi.auth(
                        user, fcmToken:
                            AppDelegate.firebaseToken)
                    userRepository.registUserInfo(userInfo)
                    
                    let isNewUser = (userInfo.job == nil &&
                    userInfo.monthlyTargetIncome == nil &&
                    userInfo.socialType == nil &&
                    userInfo.socialId == nil)
                    
                    if isNewUser {
                        self.isLoading = false
                        coordinator?.send(.initialSetting)
                    } else {
                        self.isLoading = false
                        coordinator?.send(.home)
                    }
                } catch {
                    printError(error)
                    self.isLoading = false
                }
            }
        }
    }
}
