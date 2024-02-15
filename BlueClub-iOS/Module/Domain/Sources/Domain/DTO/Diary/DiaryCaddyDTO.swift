//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public struct DiaryCaddyDTO: DiaryDTO {
    public var id: Int?
    public let worktype: String
    public let memo: String
    public let income: Int
    public let expenditure: Int
    public let saving: Int
    public let date: String
    public let rounding: Int
    public let caddyFee: Int
    public let overFee: Int
    public let topdressing: Bool
    
    public var dateDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
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
        rounding: Int,
        caddyFee: Int,
        overFee: Int,
        topdressing: Bool
    ) {
        self.id = id
        self.worktype = worktype
        self.memo = memo
        self.income = income
        self.expenditure = expenditure
        self.saving = saving
        self.date = date
        self.rounding = rounding
        self.caddyFee = caddyFee
        self.overFee = overFee
        self.topdressing = topdressing
    }
}

public protocol DiaryDTO: Codable { }
