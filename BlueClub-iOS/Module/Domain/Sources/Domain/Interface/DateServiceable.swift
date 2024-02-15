//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public protocol DateServiceable {
    
    /* NOTE
     monthIndex: 0은 이번달, 1은 다음달, -1은 이전달
     */
    func toDayInt(_ monthIndex: Int) -> (Int, Int, Int)
    
    func getToday() -> Day
    
    func getDaysOf(_ monthIndex: Int) -> [Day?]
    
    //------------------------------------------------------------//
    
    /* NOTE
     return: (2024, 1, 31)
     */
    func dateToInts(_ date: Date) -> (Int, Int, Int)
    
    
    /* NOTE
     return: 31 28 30...
     */
    func daysOfMonth(date: Date) -> Int?
    
    func dayOf(year: Int, month: Int, day: Int) -> Day?
    
    func dateOf(year: Int, month: Int, day: Int) -> Date?
}
