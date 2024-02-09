//
//  MyPageViewModel.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/8/24.
//

import Foundation
import DependencyContainer
import DataSource
import Architecture
import Domain

class MyPageViewModel: ObservableObject {
    
    private let coordinator: MyPageCoordinator
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    var user: AuthDTO?
    var monthlyTarget: Int {
        (user?.monthlyTargetIncome ?? 0) / 10000
    }
    @Published var appVersion: String
    
    init(
        coordinator: MyPageCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.user = userRepository.getUserInfo()
    }
}

extension MyPageViewModel: Actionable {
    
    enum Action {
        case notification
        case profileEdit
        case didTapButton(MyPageHeaderButton)
        case didTapListItem(MyPageItemRow)
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .notification:
            coordinator.send(.notification)
            
        case .profileEdit:
            coordinator.send(.profileEdit)
            
        case .didTapButton(let headerButton):
            switch headerButton {
            case .friend:
                break
            case .ask:
                break
            case .service:
                break
            }
            
        case .didTapListItem(let item):
            switch item {
            case .announcement:
                coordinator.send(.announcement)
            case .notificationSetting:
                break
            case .termsOf:
                break
            case .privacy:
                break
            case .versionInfo:
                break
            }
        }
    }
}
