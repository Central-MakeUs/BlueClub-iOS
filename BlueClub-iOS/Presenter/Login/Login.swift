//
//  Login.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import ComposableArchitecture
import Domain
import DependencyContainer
import KakaoSDKUser

@Reducer
struct Login {
    
    weak var coordinator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(coordinator: AppCoordinator, dependencies: Container = .live) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }

    struct State: Equatable { }
    
    enum Action {
        case didSelectLoginMethod(LoginMethod)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectLoginMethod(let method):
                
                switch method {
                case .apple:
                    return .run { send in
                        
                        // _ = try await userRepository.requestLogin(method)
                        // 맞다면 -> Home
                        // await coordinator?.send(.home)
                        // 아니라면 -> InitialSetting
                        
                        try await Task.sleep(for: .seconds(0.5))
                        await coordinator?.send(.initialSetting)
                    }
                case .kakao:
                    let hasKakao = UserApi.isKakaoTalkLoginAvailable()
                    switch hasKakao {
                    case true:
                        UserApi.shared.loginWithKakaoTalk { auth, error in
                            print(auth, error)
                        }
                    case false:
                        UserApi.shared.loginWithKakaoAccount { auth, error in
                            print(auth, error)
                        }
                    }
                    return .none
                case .naver:
                    return .none
                }
            }
        }
    }
}
