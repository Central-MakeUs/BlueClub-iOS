//
//  ScheduleEditViewModel.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/6/24.
//

import Foundation
import DependencyContainer
import Domain
import Architecture
import DataSource

class ScheduleEditViewModel: ObservableObject {
    
    // MARK: - Datas
    @Published var showScheduleTypeSheet = false
    @Published var job: JobOption = .caddy
    @Published var scheduleType: ScheduleType?
    @Published var date: Date = .now
    
    // MARK: - Cadday Datas
    @Published var roundingCount = 0
    @Published var caddyFee = ""
    @Published var overFee = ""
    @Published var topDressing = false
    
    // MARK: - Rider Datas
    @Published var deliveryCount = 0
    @Published var deliveryIncome = ""
    @Published var promotionCount = 0
    @Published var promotionIncome = ""
    
    // MARK: - Temporary Datas
    @Published var siteName = ""
    @Published var dayIncome = ""
    @Published var category = ""
    @Published var gongsu: Double = 0.0
    
    // MARK: - Dependencies
    weak var coordinator: ScheduleNoteCoordinator?
//    private let dependencies: Container
//    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    private var userRepository: UserRepositoriable = UserRepository(dependencies: .live)
    
//    init(
//        coordinator: ScheduleNoteCoordinator,
//        dependencies: Container
//    ) {
//        self.coordinator = coordinator
//        self.dependencies = dependencies
//    }
    
    init(coordinator: ScheduleNoteCoordinator) {
        self.coordinator = coordinator
    }
}

extension ScheduleEditViewModel: Actionable {

    enum Action {
        case fetchUserInfo
        case didTapScheduleType
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchUserInfo:
//            let userInfo = userRepository.getUserInfo()
//            self.job = .init(title: userInfo?.job ?? "")
            break
        case .didTapScheduleType:
            self.showScheduleTypeSheet = true
        }
    }
}

enum ScheduleType: CaseIterable {
    case work, skipOff, dayOff
    
    var title: String {
        switch self {
        case .work:
            return "근무"
        case .skipOff:
            return "조퇴"
        case .dayOff:
            return "휴무"
        }
    }
}
