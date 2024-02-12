//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public struct DiaryListDTO: Codable {
    
    public let totalDay: Int
    public let monthlyRecord: [MonthlyRecord]
    
    public struct MonthlyRecord: Codable, Identifiable {
        public let id: Int
        public let date: String
        public let worktype: String
        public let income: Int
        public let cases: Int?
        
        public var incomeLabel: String {
            String(income / 10000) + "만원"
        }
    }
}
