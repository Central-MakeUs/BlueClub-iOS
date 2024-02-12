//
//  File.swift
//  
//
//  Created by 김인섭 on 2/12/24.
//

import Foundation

public enum WorkType: CaseIterable {
    case work, skipOff, dayOff
    
    public init?(rawValue: String) {
        switch rawValue {
        case "근무":
            self = .work
        case "조퇴":
            self = .skipOff
        case "휴무":
            self = .dayOff
        default:
            return nil
        }
    }
    
    public var title: String {
        switch self {
        case .work:
            return "근무"
        case .skipOff:
            return "조퇴"
        case .dayOff:
            return "휴무"
        }
    }
}
