//
//  MyPageCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/8/24.
//

import Navigator
import Architecture

final class MyPageCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension MyPageCoordinator: Coordinatorable {
    
    enum Action {
        case notification
        
        // MARK: - Header
        case profileEdit
        case inviteFriend
        case ask
        case service
        
        case announcement
        case notificationSetting
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
            
        // MARK: - Header
        case .profileEdit:
            let viewModel = ProfileEditViewModel(coordinator: self)
            let view = ProfileEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .inviteFriend:
            break
            
        case .ask:
            break
            
        case .service:
            break
            
        case .announcement:
            let view = AnnouncementView()
            navigator.push { view }
            
        case .notificationSetting:
            break
        }
    }
}
