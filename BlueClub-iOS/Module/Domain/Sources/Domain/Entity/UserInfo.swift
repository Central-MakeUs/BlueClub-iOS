//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public struct UserInfo: Codable {
    
    public var nickname: String
    public var job: JobOption
    
    public init(nickname: String, job: JobOption) {
        self.nickname = nickname
        self.job = job
    }
}
