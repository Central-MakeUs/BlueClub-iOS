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
        case notice
        case scheduleNoteEdit(Int) // targetIncome
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .notice:
            let view = NoticeListView(navigator: self.navigator)
            navigator.push { view }
            
        case .scheduleNoteEdit(let target):
            parent?.send(.scheduleNoteEdit(target))
            
        }
    }
}
