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
    private var userRepository: UserRepositoriable { dependencies.resolve() }
    
    init(
        coordinator: ScheduleNoteCoordinator,
        dependencies: Container = .live
    ) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        Task {
            await self.send(.fetchGoal)
            await self.send(.fetchDiaryList)
        }
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
                    if var user = self.userRepository.getUserInfo() {
                        user.monthlyTargetIncome = target
                        userRepository.registUserInfo(user)
                    }
                    self.send(.fetchGoal)
                } catch {
                    printError(error)
                }
            }
            
        case .scheduleEdit:
            guard let goal else { return }
            
            let currentDay = dateService.getToday().combinedDateString
            let found = self.diaryList.first(where: { $0.date == currentDay })
            
            if let found {
                self.coordinator?.send(.scheduleEditById(goal.targetIncome, found.id))
            } else {
                self.coordinator?.send(.scheduleEdit(goal.targetIncome))
            }
            
        case .scheduleEditById(let id):
            guard let goal else { return }
            coordinator?.send(.scheduleEditById(goal.targetIncome, id))
            
        case .scheduleEditByDate(let date):
            guard let goal else { return }
            coordinator?.send(.scheduleEditByDate(goal.targetIncome, date))
        }
    }
}
