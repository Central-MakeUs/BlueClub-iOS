//
//  Login.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import ComposableArchitecture
import Domain
import DependencyContainer

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
                        _ = try await userRepository.requestLogin(method)
                        // TODO: - 서버에 회원가입한 유저인지 확인 요청
                        // 맞다면 -> Home
                        // await coordinator?.send(.home)
                        // 아니라면 -> SignUp
                        try await Task.sleep(for: .seconds(0.5))
                        await coordinator?.send(.signup)
                    }
                case .kakao:
                    return .none
                case .naver:
                    return .none
                }
            }
        }
    }
}
