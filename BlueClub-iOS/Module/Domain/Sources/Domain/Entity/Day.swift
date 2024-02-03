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
