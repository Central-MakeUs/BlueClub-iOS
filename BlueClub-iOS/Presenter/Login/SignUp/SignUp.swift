//
//  SignUp.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import ComposableArchitecture
import Domain

@Reducer
struct SignUp {
    
    struct State: Equatable {
        // MARK: - Sheet
        @BindingState var showSelectYearSheet = false
        @BindingState var showAllowSheet = false
        @BindingState var showSelectTelecomSheet = false
        
        // MARK: - RegisterInfo
        @BindingState var focusState: FocusItem? = .none
        @BindingState var email = ""
        @BindingState var password = ""
        @BindingState var passwordConfirm = ""
        @BindingState var name = ""
        @BindingState var telecom: SelectTelecomView.Telecom? = .none
        @BindingState var phoneNumber = ""
        @BindingState var verificationCode = ""
        @BindingState var hasAllow = false
        
        var currentStage: Stage = .jobSelection
        var selectedJob: JobOption? = .none
        @BindingState var startYear: Int? = .none
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case didTapBack
        case setStage(Stage)
        case didSelectJob(JobOption)
        case setFocusState(FocusItem)
        case didSelectLoginMethod(LoginMethod)
        
        // MARK: - Sheet
        case showSelectYearSheet
        case showAllowSheet
        case didFinishAllow
        case showSelectTelecomSheet
    }
    
    weak var cooridonator: LoginCoordinator?
    
    init(cooridonator: LoginCoordinator) {
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
                case .jobSelection:
                    cooridonator?.navigator?.pop()
                    return .none
                case .startYear:
                    state.startYear = .none
                    return .send(.setStage(.jobSelection))
                case .register:
                    return .send(.setStage(.startYear))
                case .registerInfo:
                    return .send(.setStage(.register))
                }
                
            case .setStage(let stage):
                state.currentStage = stage
                return .none
                
            case .didSelectJob(let job):
                state.selectedJob = job
                return .send(.setStage(.startYear))
                
            case .setFocusState(let focusItem):
                state.focusState = focusItem
                return .none
                
                
            case .didSelectLoginMethod(let method):
                switch method {
                case .kakao, .apple:
                    return .send(.showAllowSheet)
                case .email:
                    return .send(.setStage(.registerInfo))
                }
                
            // MARK: - Sheet
            case .showSelectYearSheet:
                state.showSelectYearSheet = true
                return .none
                
            case .showAllowSheet:
                state.showAllowSheet = true
                return .none
                
            case .didFinishAllow:
                state.showAllowSheet = false
                return .none
                
            case .showSelectTelecomSheet:
                state.showSelectTelecomSheet = true
                return .none
            }
        }
    }
}

extension SignUp {

    enum Stage: CaseIterable {
        case jobSelection, startYear, register, registerInfo
        
        var int: Int {
            switch self {
            case .jobSelection:
                return 1
            case .startYear:
                return 2
            case .register:
                return 3
            case .registerInfo:
                return 4
            }
        }
        
        var title: String {
            switch self {
            case .jobSelection:
                return "직업 설정"
            case .startYear:
                return "연차 설정"
            case .register:
                return "회원가입"
            case .registerInfo:
                return "회원가입"
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
    
    enum FocusItem {
        case email, password, passwordConfirm, name, phoneNumber, verificationCode
    }
}
