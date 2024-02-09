//
//  ProfileEditViewModel.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation
import DependencyContainer
import Architecture
import Domain
import Combine
import SwiftUI
import Utility
import DataSource

class ProfileEditViewModel: ObservableObject {
    
    // MARK: - Datas
    var user: AuthDTO?
    
    var isAvailable: Bool {
        nicknameHasChange && nicknameAvailable ||
        jobHasChange ||
        monthlyGoalHasChange && monthlyGoalValid
    }
    
    @Published var nickname = ""
    @Published var nicknameValid = false
    @Published var nicknameMessage: (String, Color)?
    @Published var nicknameAvailable = false
    var nicknameHasChange: Bool {
        user?.nickname != nickname
    }
    
    @Published var job: JobOption = .caddy
    @Published var showJobSelect = false
    var jobHasChange: Bool {
        user?.job != job.title
    }
    
    @Published var monthlyGoal = ""
    @Published var monthlyGoalValid = false
    var monthlyGoalInt: Int {
        let clean = monthlyGoal.replacingOccurrences(of: ",", with: "")
        return Int(clean) ?? 0
    }
    var monthlyGoalHasChange: Bool {
        user?.monthlyTargetIncome != monthlyGoalInt
    }
    
    // MARK: - Dependencies
    private let coordinator: MyPageCoordinator
    private let container: Container
    private var userRepository: UserRepositoriable { container.resolve() }
    private var validateNickname: ValidateUserNameUseCase { container.resolve() }
    private var authService: AuthServiceable { container.resolve() }
    private var userService: UserServiceable { container.resolve() }
    
    init(
        coordinator: MyPageCoordinator,
        container: Container = .live
    ) {
        self.coordinator = coordinator
        self.container = container
        
        self.user = userRepository.getUserInfo()
        self.nickname = user?.nickname ?? ""
        self.job = .init(title: user?.job ?? "")
        self.monthlyGoal = String(user?.monthlyTargetIncome ?? 0)
    }
}

extension ProfileEditViewModel: Actionable {
    
    enum Action {
        case pop
        case didTapEdit
        case getImage
        case showJobSelect
        case logout
        case withdraw
        case nicknameDidChange
        case chekcDuplicate
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .pop:
            coordinator.pop()
            
        case .didTapEdit:
            Task {
                do {
                    let dto: DetailsDTO = .init(
                        nickname: self.nickname,
                        job: self.job.title,
                        monthlyTargetIncome: monthlyGoalInt)
                    try await userService.detailsPatch(dto)
                    
                    var user = userRepository.getUserInfo()
                    user?.nickname = dto.nickname
                    user?.job = dto.job
                    user?.monthlyTargetIncome = dto.monthlyTargetIncome
                    if let user {
                        userRepository.registUserInfo(user)
                    }
                    coordinator.pop()
                } catch {
                    printError(error)
                }
            }
            
        case .getImage:
            break
            
        case .showJobSelect:
            self.showJobSelect = true
            
        case .logout:
            break
            
        case .withdraw:
            break
            
        case .nicknameDidChange:
            self.nicknameAvailable = false
            self.nickname = String(nickname.prefix(10))
            self.nicknameValid = validateNickname.execute(nickname)
            if !nicknameValid {
                self.nicknameMessage = ("띄어쓰기 없이 한글, 영문, 숫자만 가능해요", .colors(.primaryNormal))
            }
            
        case .chekcDuplicate:
            Task {
                do {
                    guard nicknameValid else { return }
                    let success = try await self.authService.duplicate(self.nickname)
                    guard success else { return }
                    self.nicknameMessage = ("사용 가능한 닉네임입니다.", .colors(.primaryNormal))
                    self.nicknameAvailable = true
                } catch {
                    printError(error)
                    guard let error = error as? ServerError else { return }
                    if error == .해당_닉네임은_중복입니다 {
                        self.nicknameMessage = ("이미 사용 중인 닉네임입니다.", .colors(.error))
                    }
                }
            }
        }
    }
}
