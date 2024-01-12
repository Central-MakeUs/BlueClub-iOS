//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public enum JobOption: CaseIterable, Codable {
    
    case caddy, rider, delivery, insurance, freelancer
    
    public var title: String {
        switch self {
        case .caddy:
            return "골프캐디"
        case .rider:
            return "배달 라이더"
        case .delivery:
            return "택배 기사"
        case .insurance:
            return "보험 설계사"
        case .freelancer:
            return "기타·프리랜서"
        }
    }
}
