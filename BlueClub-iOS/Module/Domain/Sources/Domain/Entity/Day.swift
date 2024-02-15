//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public struct Day: Equatable {
    
    public let year: Int
    public let month: Int
    public let day: Int
    public let weekday: WeekDay
    public var combinedDateString: String {
        combine(year: year, month: month, day: day)
    }
    
    public init(
        year: Int,
        month: Int,
        day: Int,
        weekday: WeekDay
    ) {
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
    }
    
    public func isSameDay(
        year: Int?,
        month: Int?,
        day: Int?
    ) -> Bool {
        
        guard
            let year,
            let month,
            let day
        else { return false }
        
        return self.year == year &&
            self.month == month &&
            self.day == day
    }
}

fileprivate func combine(year: Int, month: Int, day: Int) -> String {
    var monthString = String(month)
    if 10 > month {
        monthString = "0" + monthString
    }
    var dayString = String(day)
    if 10 > day {
        dayString = "0" + dayString
    }
    return String(year) + "-" + monthString + "-" + dayString
}
