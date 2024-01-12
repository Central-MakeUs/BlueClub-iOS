//
//  SignUp.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import ComposableArchitecture
import Domain
import SwiftUI
import DesignSystem
import DependencyContainer

@Reducer
struct SignUp {
    
    struct State: Equatable {

        @BindingState var showSelectYearSheet = false
        @BindingState var showAllowSheet = false
        
        @BindingState var startYear: Int? = .none
        @BindingState var nickname = ""
        @BindingState var hasAllow = false
        @BindingState var showKeyboard: Bool? = false
        
        var message: Messages?
        
        var currentStage: Stage = .job
        var selectedJob: JobOption? = .none
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case didTapBack
        case setStage(Stage)
        case didSelectJob(JobOption)
        case didSelectLoginMethod(LoginMethod)
        case nicknameDidChange
        case didFinishSignUp
        case showKeyboard
        
        // MARK: - Sheet
        case showSelectYearSheet
        case showAllowSheet
        case didFinishAllow
    }
    
    weak var cooridonator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(cooridonator: AppCoordinator, container: Container = .live) {
        self.cooridonator = cooridonator
        self.dependencies = container
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .didTapBack:
                switch state.currentStage {
                case .job:
                    return .run { send in
                        await cooridonator?.navigator?.pop()
                    }
                case .startYear:
                    state.startYear = .none
                    return .send(.setStage(.job))
                case .nickname:
                    return .send(.setStage(.startYear))
                case .welcome:
                    return .none
                }
                
            case .setStage(let stage):
                state.currentStage = stage
                switch stage {
                case .nickname:
                    return .send(.showKeyboard)
                case .welcome:
                    let userInfo = UserInfo(
                        nickname: state.nickname,
                        job: state.selectedJob!,
                        startYear: state.startYear!)
                    return .run { send in
                        userRepository.registUserInfo(userInfo)
                    }
                default:
                    return .none
                }
                
            case .didSelectJob(let job):
                state.selectedJob = job
                return .send(.setStage(.startYear))
                
            case .didSelectLoginMethod(let method):
                switch method {
                case .kakao, .naver, .apple:
                    return .send(.showAllowSheet)
                }
                
            case .nicknameDidChange:
                if state.nickname.count > 10 {
                    state.nickname = String(state.nickname.prefix(10))
                }
                return .none
                
            case .didFinishSignUp:
                return .run { send in
                    await cooridonator?.send(.home)
                }
                
            case .showKeyboard:
                state.showKeyboard = true
                return .none
                
            // MARK: - Sheet
            case .showSelectYearSheet:
                state.showSelectYearSheet = true
                return .none
                
            case .showAllowSheet:
                state.showAllowSheet = true
                return .none
                
            case .didFinishAllow:
                state.showAllowSheet = false
                state.currentStage = .welcome
                return .none
            }
        }
    }
}

extension SignUp {

    enum Stage: CaseIterable {
        case job, startYear, nickname, welcome
        
        var int: Int {
            switch self {
            case .job:
                return 1
            case .startYear:
                return 2
            case .nickname:
                return 3
            case .welcome:
                return 4
            }
        }
        
        var title: String {
            switch self {
            case .job:
                return "직업 설정"
            case .startYear:
                return "연차 설정"
            case .nickname:
                return "닉네임 설정"
            case .welcome:
                return "블루클럽 가입을 축하드립니다"
            }
        }
    }
    
    enum Messages {
        case availableNickname, duplicateNickname
        
        var message: String {
            switch self {
            case .availableNickname:
                return "사용 가능한 닉네임 입니다."
            case .duplicateNickname:
                return "중복된 닉네임 입니다."
            }
        }
        
        var color: Color {
            switch self {
            case .availableNickname:
                return Color.colors(.primaryNormal)
            case .duplicateNickname:
                return Color.colors(.error)
            }
        }
    }
}
