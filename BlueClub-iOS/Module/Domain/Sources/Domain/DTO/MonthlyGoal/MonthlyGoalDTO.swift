//
//  File.swift
//  
//
//  Created by 김인섭 on 2/11/24.
//

import Foundation

public struct MonthlyGoalDTO: Codable {
    public let targetIncome: Int
    public let totalIncome: Int
    public let progress: Int
    public var progorssFloat: CGFloat {
        CGFloat(progress / 100)
    }
    public var targeIncomeLabel: String {
        String(targetIncome / 10000) + "만원"
    }
}
