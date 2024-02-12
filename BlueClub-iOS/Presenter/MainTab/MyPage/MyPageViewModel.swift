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
import UIKit

class MyPageViewModel: ObservableObject {
    
    private let coordinator: MyPageCoordinator
    private let dependencies: Container
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    @Published var show이용약관 = false
    @Published var show개인정보 = false
    @Published var user: AuthDTO?
    @Published var appVersion: String?
    var monthlyTarget: Int {
        (user?.monthlyTargetIncome ?? 0) / 10000
    }
    
    init(
        coordinator: MyPageCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

extension MyPageViewModel: Actionable {
    
    enum Action {
        case fetchUser
        case fetchAppVersion
        case notice
        case profileEdit
        case didTapButton(MyPageHeaderButton)
        case didTapListItem(MyPageItemRow)
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .fetchUser:
            self.user = userRepository.getUserInfo()
            
        case .fetchAppVersion:
            self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
        case .notice:
            coordinator.send(.notice)
            
        case .profileEdit:
            coordinator.send(.profileEdit)
            
        case .didTapButton(let headerButton):
            switch headerButton {
            case .friend:
                break
            case .ask:
                coordinator.send(.ask)
            case .service:
                coordinator.send(.service)
            }
            
        case .didTapListItem(let item):
            switch item {
            case .notice:
                coordinator.send(.notice)
                
            case .notificationSetting:
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                
            case .termsOf:
                self.show이용약관 = true
                
            case .privacy:
                self.show개인정보 = true
                
            case .versionInfo:
                break
            }
        }
    }
}
