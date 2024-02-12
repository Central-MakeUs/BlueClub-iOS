//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct DiaryRiderDTO: DiaryDTO {
    
    public let worktype: String
    public let memo: String
    public let income: Int
    public let expenditure: Int
    public let saving: Int
    public let date: String?
    public let numberOfDeliveries: Int
    public let incomeOfDeliveries: Int
    public let numberOfPromotions: Int
    public let incomeOfPromotions: Int
    
    public init(
        worktype: String,
        memo: String,
        income: Int,
        expenditure: Int,
        saving: Int,
        date: String?,
        numberOfDeliveries: Int,
        incomeOfDeliveries: Int,
        numberOfPromotions: Int,
        incomeOfPromotions: Int
    ) {
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
