//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import Foundation

public enum WeekDay: Int, CaseIterable {
    case sun = 0
    case mon = 1
    case tues = 2
    case wed = 3
    case thurs = 4
    case fri = 5
    case sat = 6
    
    public var title: String {
        switch self {
        case .sun:
            return "일"
        case .mon:
            return "월"
        case .tues:
            return "화"
        case .wed:
            return "수"
        case .thurs:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        }
    }
}
