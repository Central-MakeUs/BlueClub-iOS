//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation
import Domain

public struct DateService: DateServiceable {
    
    public init() { }
    
    private var dateFrom: (Int) -> Date {{ monthIndex in
        Calendar
            .current
            .date(
                byAdding: .month,
                value: monthIndex,
                to: .now)!
    }}
    
    public func toDayInt(_ monthIndex: Int) -> (Int, Int, Int) {
        let date = dateFrom(monthIndex)
        return dateToInts(date)
    }
    
    public func getToday() -> Day {
        let (yearInt, monthInt, dayInt) = dateToInts(Date())
        return dayOf(
            year: yearInt,
            month: monthInt,
            day: dayInt)!
    }
    
    public func getDaysOf(_ monthIndex: Int) -> [Day?] {
        let (year, month, day) = toDayInt(monthIndex)
        
        guard 
            let date = dateOf(year: year, month: month, day: day),
            let daysCount = daysOfMonth(date: date),
            let firstDay = dayOf(
                year: year,
                month: month,
                day: 1)
        else { return [] }
        
        let prependDays = firstDay.weekday.rawValue
        var result: [Day?] = Array(
            repeating: .none,
            count: prependDays)
        
        (1...daysCount).forEach {
            let day = dayOf(year: year, month: month, day: $0)
            result.append(day)
        }
        
        return result
    }
    
    //------------------------------------------------------------//
    
    public func dateToInts(_ date: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (year, month, day)
    }
    
    public func daysOfMonth(date: Date) -> Int? {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }
    
    public func dayOf(year: Int, month: Int, day: Int) -> Day? {
        let date = dateOf(
            year: year,
            month: month,
            day: day)
        guard let date else { return .none }
        let weekdayInt = Calendar
            .current
            .component(.weekday, from: date) - 1
        guard let weekday = WeekDay(rawValue: weekdayInt) else { return .none }
        return .init(
            year: year,
            month: month,
            day: day,
            weekday: weekday)
    }
    
    public func dateOf(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar.current
        var component = DateComponents()
        component.day = 1
        component.year = year
        component.month = month
        return calendar.date(from: component)
    }
}
