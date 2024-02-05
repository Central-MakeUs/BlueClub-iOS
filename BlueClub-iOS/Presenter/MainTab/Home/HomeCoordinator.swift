//
//  HomeCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Navigator
import Architecture

final class HomeCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension HomeCoordinator: Coordinatorable {
    
    enum Action {
        case notification
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
        }
    }
}
