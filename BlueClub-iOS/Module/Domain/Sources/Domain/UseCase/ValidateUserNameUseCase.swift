//
//  File.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import Foundation

public struct ValidateUserNameUseCase {
    
    public init() { }
    
    public func execute(_ nickname: String) -> Bool {
        let pattern = "^[가-힣A-Za-z0-9]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: nickname.utf16.count)
        return regex?.firstMatch(in: nickname, options: [], range: range) != nil
    }
}
