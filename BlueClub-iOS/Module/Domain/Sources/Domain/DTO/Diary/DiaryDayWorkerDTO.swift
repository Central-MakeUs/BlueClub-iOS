//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct DiaryDayWorkerDTO: DiaryDTO {
    
    public let worktype: String
    public let memo: String
    public let income: Int
    public let expenditure: Int
    public let saving: Int
    public let date: String
    public let place: String
    public let dailyWage: Int
    public let typeOfJob: String
    public let numberOfWork: Double
    
    public var dateDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: date) ?? .now
    }
    
    public init(
        worktype: String,
        memo: String,
        income: Int,
        expenditure: Int,
        saving: Int,
        date: String,
        place: String,
        dailyWage: Int,
        typeOfJob: String,
        numberOfWork: Double
    ) {
        self.worktype = worktype
        self.memo = memo
        self.income = income
        self.expenditure = expenditure
        self.saving = saving
        self.date = date
        self.place = place
        self.dailyWage = dailyWage
        self.typeOfJob = typeOfJob
        self.numberOfWork = numberOfWork
    }
}
