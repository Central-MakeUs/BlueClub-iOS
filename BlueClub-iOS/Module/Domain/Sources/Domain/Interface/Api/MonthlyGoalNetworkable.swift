//
//  File.swift
//  
//
//  Created by 김인섭 on 2/11/24.
//

import Foundation

public protocol MonthlyGoalNetworkable {
    
    func post(year: Int, month: Int, targetIncome: Int) async throws
    func get(year: Int, month: Int) async throws -> MonthlyGoalDTO
}
