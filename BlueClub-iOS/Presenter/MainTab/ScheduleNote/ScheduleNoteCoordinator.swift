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
        case scheduleEdit
        case scheduleEditById(Int?)
        case scheduleEditByDate(String)
        
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
            
        case .scheduleEdit:
            let viewModel = ScheduleEditViewModel(coordinator: self)
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .scheduleEditById(let diaryId):
            let viewModel = ScheduleEditViewModel(coordinator: self)
            if let diaryId {
                viewModel.send(.fetchDetail(diaryId))
            }
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .scheduleEditByDate(let date):
            let viewModel = ScheduleEditViewModel(coordinator: self)
            viewModel.send(.editByDate(date))
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        }
    }
}
