//
//  ScheduleNote.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ScheduleNote {
    
    struct State: Equatable {
        
        static func == (lhs: ScheduleNote.State, rhs: ScheduleNote.State) -> Bool {
            lhs.monthIndex == rhs.monthIndex &&
            lhs.days.count == rhs.days.count
        }
        
        var amount = 5_000_000
        var progress = 0.8
        var percent: Int { Int(progress * 100) }
        var 만원단위: Int { Int(amount / 1000) }
        var days: [Day?] = []
        
        var monthIndex = 0 // 0은 이번달, 1은 다음달, -1은 전달
        var currentYear: Int?
        var currentMonth: Int?
    }
    enum Action {
        case getDays // yearInt, monthInt
        case getDaysOf(Int, Int)
        case increaseMonth
        case decreaseMonth
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .getDays:
                let date = Calendar.current.date(byAdding: .month, value: state.monthIndex, to: .now)!
                let (yearInt, monthInt, _) = dateToInts(date)
                state.currentYear = yearInt
                state.currentMonth = monthInt
                return .run { send in await send(.getDaysOf(yearInt, monthInt)) }
                
            case .getDaysOf(let year, let month):
                
                guard let date = dateOf(year: year, month: month, day: 1),
                      let dayCount = daysOfMonth(date: date)
                else { return .none }
                
                let firstDay = dayOf(
                    year: year,
                    month: month,
                    day: 1)!
                
                let prependDays = firstDay.weekday.rawValue
                
                state.days = Array(repeating: .none, count: prependDays)
                
                for day in  1...dayCount {
                    let day = dayOf(
                        year: year,
                        month: month,
                        day: day)
                    state.days.append(day)
                }
                
                return .none
                
            case .increaseMonth:
                state.monthIndex += 1
                return .run { send in await send(.getDays) }
                
            case .decreaseMonth:
                state.monthIndex -= 1
                return .run { send in await send(.getDays) }
            }
        }
    }
}

extension ScheduleNote {
    
    func dateToInts(_ date: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (year, month, day)
    }
    
    func daysOfMonth(date: Date) -> Int? {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }
    
    func dayOf(year: Int, month: Int, day: Int) -> Day? {
        let date = dateOf(year: year, month: month, day: day)
        guard let date else { return .none }
        let weekdayInt = Calendar.current.component(.weekday, from: date) - 1
        guard let weekday = WeekDay(rawValue: weekdayInt) else { return .none }
        return .init(
            year: year,
            month: month,
            day: day,
            weekday: weekday)
    }
    
    func dateOf(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar.current
        var component = DateComponents()
        component.day = 1
        component.year = year
        component.month = month
        return calendar.date(from: component)
    }
}

struct Day {
    let year: Int
    let month: Int
    let day: Int
    let weekday: WeekDay
}

enum WeekDay: Int, CaseIterable {
    case sun = 0
    case mon = 1
    case tues = 2
    case wed = 3
    case thurs = 4
    case fri = 5
    case sat = 6
    
    var title: String {
        switch self {
        case .sun:
            return "일"
        case .mon:
            return "월"
        case .tues:
            return "화"
        case .wed:
            return "수"
        case .thurs:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        }
    }
}
