//
//  MyPageCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/8/24.
//

import Navigator
import Architecture
import UIKit

final class MyPageCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension MyPageCoordinator: Coordinatorable {
    
    enum Action {
        case notification
        case login
        
        // MARK: - Header
        case profileEdit
        case inviteFriend
        case ask
        case service
        
        case announcement
        case announcementDetail
        case notificationSetting
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
            
        case .login:
            guard let coordinator = SceneDelegate.coordinator
            else { return }
            let viewModel = LoginViewModel(coordinator: coordinator)
            let view = LoginView(viewModel: viewModel)
            navigator.start { view }
            
        // MARK: - Header
        case .profileEdit:
            let viewModel = ProfileEditViewModel(coordinator: self)
            let view = ProfileEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .inviteFriend:
            break
            
        case .ask:
            guard let url = URL(string: "https://pf.kakao.com/_mxkCiG") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case .service:
            guard let url = URL(string: "https://forms.gle/AtRshbAM2FBKMgAX8") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        case .announcement:
            let view = AnnouncementView(coordinator: self)
            navigator.push { view }
            
        case .announcementDetail:
            let view = AnnouncementDetailView(coordinator: self)
            navigator.push { view }
            
        case .notificationSetting:
            break
        }
    }
}
