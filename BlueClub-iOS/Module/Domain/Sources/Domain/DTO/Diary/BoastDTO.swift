//
//  File.swift
//  
//
//  Created by 김인섭 on 2/13/24.
//

import SwiftUI

public struct BoastDTO: Codable {
    
    public let job: String
    public let workAt: String
    public let rank: String
    public let income: Int
    public let cases: Int?
    
    public var dateLabel: String {
        workAt.replacingOccurrences(of: "-", with: ".")
    }
    
    public var imageName: String {
        if self.rank.contains("5") {
            return "goldCoin"
        } else if self.rank.contains("30") {
            return "silverCoin"
        } else {
            return "bronzeCoin"
        }
    }
    
    public init(job: String, workAt: String, rank: String, income: Int, cases: Int?) {
        self.job = job
        self.workAt = workAt
        self.rank = rank
        self.income = income
        self.cases = cases
    }
    
    public static let mock = Self(
        job: "골프캐디",
        workAt: "2024-02-10",
        rank: "상위 5%",
        income: 300000,
        cases: 1)
}
