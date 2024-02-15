//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct DiaryRiderDTO: DiaryDTO {
    public var id: Int?
    public let worktype: String
    public let memo: String
    public let income: Int
    public let expenditure: Int
    public let saving: Int
    public let date: String
    public let numberOfDeliveries: Int
    public let incomeOfDeliveries: Int
    public let numberOfPromotions: Int
    public let incomeOfPromotions: Int
    
    public var dateDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.date(from: date) ?? .now
    }
    
    public init(
        id: Int? = nil,
        worktype: String,
        memo: String,
        income: Int,
        expenditure: Int,
        saving: Int,
        date: String,
        numberOfDeliveries: Int,
        incomeOfDeliveries: Int,
        numberOfPromotions: Int,
        incomeOfPromotions: Int
    ) {
        self.id = id
        self.worktype = worktype
        self.memo = memo
        self.income = income
        self.expenditure = expenditure
        self.saving = saving
        self.date = date
        self.numberOfDeliveries = numberOfDeliveries
        self.incomeOfDeliveries = incomeOfDeliveries
        self.numberOfPromotions = numberOfPromotions
        self.incomeOfPromotions = incomeOfPromotions
    }
}
