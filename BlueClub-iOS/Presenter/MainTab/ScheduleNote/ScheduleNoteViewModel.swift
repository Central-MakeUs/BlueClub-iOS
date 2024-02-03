//
//  ScheduleNote.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/13/24.
//

import Foundation
import Architecture
import Domain
import DataSource
import DependencyContainer
import SwiftUI

final class ScheduleNoteViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let dependencies: Container
    private var dateService: DateServiceable { dependencies.resolve() }
    weak var coordinator: ScheduleNoteCoordinator?
    
    init(
        dependencies: Container = .live,
        coordinator: ScheduleNoteCoordinator
    ) {
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    // MARK: - Data
    @Published var showInputView = false
    @Published var hasExpand = false
    @Published var 목표수입 = 10_000_000
    @Published var 달성수입 = 5_000_000
    var progress: CGFloat { CGFloat(목표수입 / 달성수입) }
    var percent: Int { Int(progress * 100) }
    
    @Published var monthIndex = 0
    var currentYear: Int {
        let (year, _, _) = dateService.toDayInt(monthIndex)
        return year
    }
    var currentMonth: Int {
        let (_, month, _) = dateService.toDayInt(monthIndex)
        return month
    }
    var days: [Day?] {
        dateService.getDaysOf(monthIndex)
    }
    var today: Day { dateService.getToday() }
}

extension ScheduleNoteViewModel: Actionable {
    
    enum Action {
        case toggleHasExpand
        case increaseMonth
        case decreaseMonth
        case getDays
        
        case didTapGearIcon
        case didTapGoalSetting
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .toggleHasExpand:
            withAnimation {
                self.hasExpand.toggle()
            }
            
        case .increaseMonth:
            monthIndex += 1
            
        case .decreaseMonth:
            monthIndex -= 1
            
        case .getDays:
            break
         
        case .didTapGearIcon, .didTapGoalSetting:
            coordinator?.send(.goalInput(self))
            
        }
    }
}
