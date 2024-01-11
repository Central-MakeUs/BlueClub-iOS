//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public struct RegisterUserInfo: Codable {
    
    public var nickname: String
    public var job: JobOption
    public var startYear: Int
    
    public init(nickname: String, job: JobOption, startYear: Int) {
        self.nickname = nickname
        self.job = job
        self.startYear = startYear
    }
}
