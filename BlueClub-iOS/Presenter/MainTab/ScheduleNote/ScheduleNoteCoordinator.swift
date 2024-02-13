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
import DependencyContainer

final class ScheduleNoteCoordinator {
    
    var navigator: Navigator
    
    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

extension ScheduleNoteCoordinator: Coordinatorable {
    
    enum Action {
        case goalInput(ScheduleNoteViewModel)
        case notice
        case scheduleEdit(Int) // targetIncome
        case scheduleEditById(Int, Int?) // targetIncome, Id
        case scheduleEditByDate(Int, String) // targetIncome. DateString
        case boast(Int)
        
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
            
        case .notice:
            let view = NoticeListView(navigator: self.navigator)
            navigator.push { view }
            
        case .scheduleEdit(let target):
            let viewModel = ScheduleEditViewModel(
                coordinator: self,
                targetIncome: target)
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .scheduleEditById(let target, let diaryId):
            let viewModel = ScheduleEditViewModel(
                coordinator: self,
                targetIncome: target)
            if let diaryId {
                viewModel.send(.fetchDetail(diaryId))
            }
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .scheduleEditByDate(let target, let date):
            let viewModel = ScheduleEditViewModel(
                coordinator: self,
                targetIncome: target)
            viewModel.send(.editByDate(date))
            let view = ScheduleEditView(viewModel: viewModel)
            navigator.push { view }
            
        case .boast(let id):
            let view = BoastView(navigator: self.navigator, diaryId: id)
            navigator.push { view }
            
        }
    }
}
