//
//  ScheduleCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Navigator
import Architecture

final class ScheduleNoteCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension ScheduleNoteCoordinator: Coordinatorable {
    
    enum Action {
        case didTapGearIcon
        case didTapGoalSetting
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .didTapGearIcon, .didTapGoalSetting:
            break
        
        }
    }
}
