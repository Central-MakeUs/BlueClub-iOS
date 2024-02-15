//
//  File.swift
//  
//
//  Created by 김인섭 on 1/8/24.
//

import Foundation

public enum LoginMethod: CaseIterable, Codable {
    case kakao, apple
    
    public var title: String {
        switch self {
        case .kakao:
            return "KAKAO"
        case .apple:
            return "APPLE"
        }
    }
}
