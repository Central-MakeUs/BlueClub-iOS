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
        case profileEdit
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
            
        case .profileEdit:
            let viewModel = ProfileEditViewModel(coordinator: self)
            let view = ProfileEditView(viewModel: viewModel)
            navigator.push { view }
        }
    }
}
