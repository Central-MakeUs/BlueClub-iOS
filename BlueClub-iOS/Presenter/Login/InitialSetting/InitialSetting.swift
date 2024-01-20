//
//  InitialSetting.swift
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
struct InitialSetting {
    
    struct State: Equatable {

        @BindingState var showAllowSheet = false
        
        @BindingState var targetIcome = ""
        var targetIcomeMessage: InputStatusMessages?
        @BindingState var nickname = ""
        var nicknameMessage: InputStatusMessages?
        var checkNicknameDisabled: Bool {
            (nickname.isEmpty && nicknameMessage == .none) ||
            (!nickname.isEmpty && nicknameMessage != .none)
        }
        @BindingState var hasAllow = false
        @BindingState var focus: FocusItem? 
        
        var currentStage: Stage = .job
        var selectedJob: JobOption? = .none
        var nicknameAvailable = false
        var isTargetIcomeValid = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case didTapBack
        case setStage(Stage)
        case didSelectJob(JobOption)
        case targetIncomeDidChange
        case nicknameDidChange
        case checkNickname
        case didFinishInitialSetting
        
        // MARK: - Sheet
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
                case .targetIncome:
                    return .send(.setStage(.job))
                case .nickname:
                    return .send(.setStage(.targetIncome))
                case .welcome:
                    return .none
                }
                
            case .setStage(let stage):
                state.currentStage = stage
                if stage == .welcome {
                    let userInfo = UserInfo(
                        nickname: state.nickname,
                        job: state.selectedJob!)
                    userRepository.registUserInfo(userInfo)
                }
                return .none
                
            case .didSelectJob(let job):
                state.selectedJob = job
                return .send(.setStage(.targetIncome))

            case .targetIncomeDidChange:
                let targetIcome = state.targetIcome.replacingOccurrences(of: ",", with: "")
                if targetIcome.isEmpty {
                    state.targetIcomeMessage = .none
                }
                if let number = Int(targetIcome) {
                    state.targetIcome = formatNumber(number)
                    let isValid = number >= 100_000
                    state.isTargetIcomeValid = isValid
                    state.targetIcomeMessage = isValid
                        ? .목표금액기준만족
                        : .목표금액기준미만
                } else {
                    state.targetIcome = ""
                }
                return .none
                
            case .nicknameDidChange:
                state.nicknameAvailable = false
                let nickname = state.nickname
                if nickname.isEmpty {
                    state.nicknameMessage = .none
                } else if nickname.count > 10 {
                    state.nickname = String(nickname.prefix(10))
                } else {
                    state.nicknameMessage = validateNickname(nickname)
                        ? .none
                        : .닉네임유효성에러
                }
                return .none
                
            case .checkNickname:
                guard !state.checkNicknameDisabled else {
                    return .none
                }
                // TODO: - API 연결해서 중복 확인하기
                let result = true
                if true {
                    state.nicknameAvailable = true
                    state.nicknameMessage = .사용가능닉네임
                } else {
                    state.nicknameAvailable = false
                    state.nicknameMessage = .중복닉네임
                }
                return .none
                
            case .didFinishInitialSetting:
                return .run { send in
                    await cooridonator?.send(.home)
                }
                
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

extension InitialSetting {
    
    enum FocusItem {
        case targetIcome, nickname
    }

    enum Stage: CaseIterable {
        case job, targetIncome, nickname, welcome
        
        var int: Int {
            switch self {
            case .job:
                return 1
            case .targetIncome:
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
            case .targetIncome:
                return "목표 금액 설정"
            case .nickname:
                return "닉네임 설정"
            case .welcome:
                return "블루클럽 가입을 축하드립니다"
            }
        }
        
        var headerTitle: String {
            switch self {
            case .job:
                return "어떤일을 하고 계시나요?"
            case .targetIncome:
                return "매달 수입 목표를 입력해주세요"
            case .nickname:
                return "닉네임을 설정해주세요"
            case .welcome:
                return "블루클럽 가입을 축하드려요!"
            }
        }
        
        var headerDescription: String {
            switch self {
            case .job:
                return "내 직업과 일치하는 항목을 골라주세요."
            case .targetIncome:
                return "목표 금액은 최소 10만원부터 입력해주세요."
            case .nickname:
                return "닉네임은 언제든 수정이 가능해요."
            case .welcome:
                return "이제 근무기록을 통해 관리하고\n나의 근무활동을 자유롭게 자랑해봐요"
            }
        }
    }
    
    enum InputStatusMessages {
        case 사용가능닉네임, 중복닉네임, 닉네임유효성에러, 목표금액기준미만, 목표금액기준만족
        
        var message: String {
            switch self {
            case .사용가능닉네임:
                return "사용 가능한 닉네임입니다."
            case .중복닉네임:
                return "이미 사용 중인 닉네임입니다."
            case .닉네임유효성에러:
                return "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
            case .목표금액기준미만:
                return "10만원 이상 입력해주세요."
            case .목표금액기준만족:
                return "멋진 목표 금액이에요!"
            }
        }
        
        var color: Color {
            switch self {
            case .사용가능닉네임, .목표금액기준만족:
                return Color.colors(.primaryNormal)
            case .중복닉네임, .닉네임유효성에러, .목표금액기준미만:
                return Color.colors(.error)
            }
        }
    }
}

fileprivate func formatNumber(_ number: Int) -> String {
    formatter.string(from: NSNumber(value: number)) ?? ""
}

fileprivate var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = ","
    formatter.usesGroupingSeparator = true
    return formatter
}

fileprivate func validateNickname(_ string: String) -> Bool {
    let pattern = "^[가-힣A-Za-z0-9]+$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: string.utf16.count)
    return regex?.firstMatch(in: string, options: [], range: range) != nil
}
