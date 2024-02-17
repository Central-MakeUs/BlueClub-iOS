//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct DiaryDayWorkerDTO: DiaryDTO {
    public var id: Int?
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
    
    public init(
        id: Int? = nil,
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
        self.id = id
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
