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
    
    func isUpdateAvailable() -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            return false
        }
        let data = try? Data(contentsOf: url)
        guard let data else { return false }
        let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
        guard let json else { return false }
        
        if let result = (json["results"] as? [Any])?.first as? [String: Any],
           let version = result["version"] as? String {
            return version != currentVersion
        }
        return false
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
        case ask
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
                
            case .appversion:
                let urlString = "https://apps.apple.com/kr/app/%EB%B8%94%EB%A3%A8%ED%81%B4%EB%9F%BD/id6477823755"
                guard let url = URL(string: urlString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
        case .ask:
            coordinator.send(.ask)
        }
    }
}
