//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public struct DiaryRecordDTO: Codable {
    
    public let totalDay: Int
    public let straightDay: Int
    public let isRenew: Bool
    public let straightMonth: Int
    public let targetIncome: Int
    public let totalIncome: Int
    public let progress: Int
}
