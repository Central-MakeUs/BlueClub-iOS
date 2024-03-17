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
        
        case login
        
        // MARK: - Header
        case profileEdit
        case inviteFriend
        
        case friend
        case ask
        case service
        
        case blueClubAppStore
        case notice
        case notificationSetting
        
        case open(urlString: String)
    }
    
    func send(_ action: Action) {
        switch action {
            
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
            
        case .friend:
            let urlString = "https://apps.apple.com/kr/app/%EB%B8%94%EB%A3%A8%ED%81%B4%EB%9F%BD/id6477823755"
            guard let url = URL(string: urlString) else { return }
            let activity = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil)
            self.navigator.present(activity)
            
        case .ask:
            let urlString = "https://pf.kakao.com/_mxkCiG/chat"
            self.send(.open(urlString: urlString))
            
        case .service:
            let urlString = "https://forms.gle/AtRshbAM2FBKMgAX8"
            self.send(.open(urlString: urlString))
        
        case .blueClubAppStore:
            let urlString = "https://apps.apple.com/kr/app/%EB%B8%94%EB%A3%A8%ED%81%B4%EB%9F%BD/id6477823755"
            self.send(.open(urlString: urlString))
            
        case .notice:
            let view = NoticeListView(navigator: self.navigator)
            navigator.push { view }
            
        case .notificationSetting:
            break
            
        case .open(let urlString):
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
