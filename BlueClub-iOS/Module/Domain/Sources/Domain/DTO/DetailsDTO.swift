//
//  File.swift
//  
//
//  Created by 김인섭 on 2/6/24.
//

import Foundation

public struct DetailsDTO: Codable {
    
    public let nickname: String
    public let job: String
    public let monthlyTargetIncome: Int
    public var tosAgree: Bool
    
    public init(
        nickname: String,
        job: String,
        monthlyTargetIncome: Int,
        tosAgree: Bool = true
    ) {
        self.nickname = nickname
        self.job = job
        self.monthlyTargetIncome = monthlyTargetIncome
        self.tosAgree = tosAgree
    }
}
