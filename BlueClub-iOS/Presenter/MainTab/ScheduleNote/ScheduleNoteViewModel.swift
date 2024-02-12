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
import Utility

final class ScheduleNoteViewModel: ObservableObject {
    
    // MARK: - Dependencies
    weak var coordinator: ScheduleNoteCoordinator?
    private let dependencies: Container
    private var dateService: DateServiceable { dependencies.resolve() }
    private var monthlyGoalApi: MonthlyGoalNetworkable { dependencies.resolve() }
    private var diaryApi: DiaryNetworkable { dependencies.resolve() }
    
    init(
        coordinator: ScheduleNoteCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    @Published var hasExpand = false
    @Published var sholdReloadProgressBar = false
    @Published var goal: MonthlyGoalDTO?
    @Published var monthIndex = 0
    
    @Published var diaryList: [DiaryListDTO.MonthlyRecord] = []
    var diaryListCount: Int {
        diaryList.count
    }
    
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
        
        case fetchGoal
        case fetchDiaryList
        case didTapGearIcon
        case didTapMonthlyGoalSetting
        case setMonthlyGoal(Int)
        case scheduleEdit
        case scheduleEditById(Int)
        case scheduleEditByDate(String)
    }
    
    @MainActor func send(_ action: Action) {
        switch action {
            
        case .toggleHasExpand:
            withAnimation {
                self.hasExpand.toggle()
            }
            
        case .increaseMonth:
            monthIndex += 1
            self.send(.fetchGoal)
            self.send(.fetchDiaryList)
            
        case .decreaseMonth:
            monthIndex -= 1
            self.send(.fetchGoal)
            self.send(.fetchDiaryList)
            
        case .fetchGoal:
            Task { @MainActor in
                do {
                    let (year, month, _) = dateService.toDayInt(self.monthIndex)
                    self.goal = try await monthlyGoalApi.get(
                        year: year,
                        month: month)
                    self.sholdReloadProgressBar.toggle()
                } catch {
                    printError(error)
                }
            }
            
        case .fetchDiaryList:
            Task { @MainActor in
                do {
                    self.diaryList = try await diaryApi.list(monthIndex: self.monthIndex)
                } catch {
                    printError(error)
                }
            }
         
        case .didTapGearIcon, .didTapMonthlyGoalSetting:
            coordinator?.send(.goalInput(self))
            
        case .setMonthlyGoal(let target):
            Task { @MainActor in
                do {
                    self.coordinator?.navigator.dismiss()
                    let (year, month, _) = dateService.toDayInt(monthIndex)
                    try await monthlyGoalApi.post(
                        year: year,
                        month: month,
                        targetIncome: target)
                    self.send(.fetchGoal)
                } catch {
                    printError(error)
                }
            }
            
        case .scheduleEdit:
            self.coordinator?.send(.scheduleEdit)
            
        case .scheduleEditById(let id):
            coordinator?.send(.scheduleEditById(id))
            
        case .scheduleEditByDate(let date):
            coordinator?.send(.scheduleEditByDate(date))
        }
    }
}
