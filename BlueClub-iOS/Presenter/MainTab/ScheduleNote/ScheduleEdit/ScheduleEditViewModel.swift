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
import UIKit
import Combine

class ScheduleEditViewModel: ObservableObject {
    
    // MARK: - Datas
    var isAvailable: Bool {
        switch self.job {
        case .caddy:
            return scheduleType != nil &&
            roundingCount > 0 &&
            !caddyFee.isEmpty
        case .rider:
            return scheduleType != nil &&
            deliveryCount > 0 &&
            !deliveryIncome.isEmpty
        case .temporary:
            return scheduleType != nil &&
            !siteName.isEmpty &&
            !dayPay.isEmpty
        }
    }
    private var cancellables = Set<AnyCancellable>()

    @Published var keyboardAppeared = false
    @Published var showScheduleTypeSheet = false
    @Published var job: JobOption = .caddy
    @Published var scheduleType: ScheduleType?
    @Published var date: Date = .now
    @Published var showMemoSheet = false
    @Published var memo = ""
    @Published var spend = ""
    @Published var saving = ""
    
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
    @Published var dayPay = ""
    @Published var category = ""
    @Published var gongsu: Double = 0.0
    
    // MARK: - Dependencies
    weak var coordinator: ScheduleNoteCoordinator?
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(
        coordinator: ScheduleNoteCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.keyboardAppeared = true
            }).store(in: &cancellables)

          // 키보드가 사라질 때
          NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.keyboardAppeared = false
            }).store(in: &cancellables)
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
