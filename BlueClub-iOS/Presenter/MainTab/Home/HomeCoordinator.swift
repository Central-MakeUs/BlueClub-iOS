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
    private weak var parent: MainTabCoordinator?
    
    init(navigator: Navigator, parent: MainTabCoordinator) {
        self.navigator = navigator
        self.parent = parent
    }
}

extension HomeCoordinator: Coordinatorable {
    
    enum Action {
        case notification
        case scheduleNoteEdit
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
            
        case .scheduleNoteEdit:
            parent?.send(.scheduleNoteEdit)
            
        }
    }
}
