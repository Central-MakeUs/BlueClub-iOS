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
    
    init(cooridonator: AppCoordinator) {
        self.cooridonator = cooridonator
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
                    cooridonator?.navigator?.pop()
                    return .none
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
                if stage == .nickname {
                    return .send(.showKeyboard)
                }
                return .none
                
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
                cooridonator?.send(.home)
                return .none
                
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
    
    enum JobOption: CaseIterable {
        
        case caddy, rider, delivery, insurance, freelancer
        
        var title: String {
            switch self {
            case .caddy:
                return "골프캐디"
            case .rider:
                return "배달 라이더"
            case .delivery:
                return "택배 기사"
            case .insurance:
                return "보험 설계사"
            case .freelancer:
                return "기타·프리랜서"
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
