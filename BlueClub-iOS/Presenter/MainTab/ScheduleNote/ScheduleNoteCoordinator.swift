//
//  ScheduleCoordinator.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Navigator
import Architecture
import UIKit

final class ScheduleNoteCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension ScheduleNoteCoordinator: Coordinatorable {
    
    enum Action {
        case goalInput(ScheduleNoteViewModel)
        case notification
        
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .goalInput(let viewModel):
            let height = UIApplication.shared.screenSize.height - 300
            let parameter = BottomSheetParameter(
                minHeight: height,
                maxHeight: height)
            let view = GoalInputSheetView(
                viewModel: viewModel,
                coordinator: self)
            navigator.bottomSheet(parameter) { view }
            
        case .notification:
            let view = NotificationView(coordinator: self)
            navigator.push { view }
        }
    }
}
