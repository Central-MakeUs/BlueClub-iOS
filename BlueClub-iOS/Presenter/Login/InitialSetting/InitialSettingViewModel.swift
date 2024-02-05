//
//  InitialSetting.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import Domain
import SwiftUI
import DesignSystem
import DependencyContainer
import DataSource
import Architecture
import Utility
import Combine

final class InitialSettingViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Dependencies
    weak var cooridonator: AppCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    private var authApi: AuthServiceable { dependencies.resolve() }
    private var userApi: UserServiceable { dependencies.resolve() }
    
    init(cooridonator: AppCoordinator, container: Container = .live) {
        self.cooridonator = cooridonator
        self.dependencies = container
    }
    
    // MARK: - Datas
    @Published var showAllowSheet = false
    @Published var targetIncome = ""
    @Published var nickname = ""
    @Published var nicknameMessage: InputStatusMessages?
    var checkNicknameDisabled: Bool {
        (nickname.isEmpty && nicknameMessage == .none) ||
        (!nickname.isEmpty && nicknameMessage != .none)
    }
    
    @Published var hasAllow = false
    @Published var focus: FocusItem?
    
    @Published var currentStage: Stage = .job
    @Published var selectedJob: JobOption? = .none
    @Published var nicknameAvailable = false
    @Published var isTargetIcomeValid = false
}

extension InitialSettingViewModel: Actionable {
    
    enum Action {
        case didTapBack
        case setStage(Stage)
        case didSelectJob(JobOption)
        case nicknameDidChange
        case checkNickname
        case didFinishInitialSetting
        case observe
        
        // MARK: - Sheet
        case showAllowSheet
        case didFinishAllow
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .didTapBack:
            switch currentStage {
            case .job:
                cooridonator?.navigator.pop()
            case .targetIncome:
                self.send(.setStage(.job))
            case .nickname:
                self.send(.setStage(.targetIncome))
            case .welcome:
                break
            }
            
        case .setStage(let stage):
            self.currentStage = stage
            
        case .didSelectJob(let job):
            self.selectedJob = job
            self.send(.setStage(.targetIncome))
            
        case .nicknameDidChange:
            self.nicknameAvailable = false
            let nickname = self.nickname
            if nickname.isEmpty {
                self.nicknameMessage = .none
            } else if nickname.count > 10 {
                self.nickname = String(nickname.prefix(10))
            } else {
                self.nicknameMessage = validateNickname(nickname)
                    ? .none
                    : .닉네임유효성에러
            }
            
        case .checkNickname:
            guard !self.checkNicknameDisabled else { return }
            Task {
                do {
                    let success = try await authApi.duplicate(self.nickname)
                    guard success else { return }
                    self.nicknameAvailable = true
                    self.nicknameMessage = .사용가능닉네임
                } catch {
                    printError(error)
                    guard let error = error as? ServerError else { return }
                    if error == .해당_닉네임은_중복입니다 {
                        self.nicknameMessage = .중복닉네임
                    }
                }
            }
            
        case .didFinishInitialSetting:
            
            let targetIncome = self.targetIncome
                .replacingOccurrences(of: ",", with: "")
            
            guard
                let selectedJob,
                let targetIncome = Int(targetIncome)
            else { return }
            Task {
                do {
                    let dto = DetailsDTO(
                        nickname: self.nickname,
                        job: selectedJob.title,
                        monthlyTargetIncome: targetIncome)
                    userRepository.updateUserInfo(dto)
                    try await userApi.detailsPost(dto)
                    cooridonator?.send(.home)
                } catch {
                    printError(error)
                }
            }
            
        case .showAllowSheet:
            self.showAllowSheet = true
            
        case .didFinishAllow:
            self.showAllowSheet = false
            self.currentStage = .welcome

        case .observe:
            $nickname
                .receive(on: DispatchQueue.main)
                .sink { value in
                    self.send(.nicknameDidChange)
                }.store(in: &cancellables)
        }
    }
}


extension InitialSettingViewModel {
    
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
        case 사용가능닉네임, 중복닉네임, 닉네임유효성에러, 목표금액기준미만, 목표금액기준만족, 목표금액초과
        
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
            case .목표금액초과:
                return "9,999만원 이하 입력해주세요."
            }
        }
        
        var color: Color {
            switch self {
            case .사용가능닉네임, .목표금액기준만족:
                return Color.colors(.primaryNormal)
            case .중복닉네임, .닉네임유효성에러, .목표금액기준미만, .목표금액초과:
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