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
    
    struct State: Equatable { }
    
    enum Action {
        case didSelectLoginMethod(LoginMethod)
    }
    
    weak var coordinator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(coordinator: AppCoordinator, dependencies: Container) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didSelectLoginMethod(let method):
                
                // TODO: - 소셜 로그인 확인
                switch method {
                case .apple:
                    return .run { send in
                        let result = try await userRepository.requestUserInfo(method)
                        print(result)
                    }
                case .kakao:
                    break
                case .naver:
                    break
                }
                
                // TODO: - 회원가입 여부로 분기 처리
                coordinator?.send(.signup)
                return .none
            }
        }
    }
}
