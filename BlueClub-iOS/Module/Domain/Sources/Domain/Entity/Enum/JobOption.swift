//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import Foundation

public enum JobOption: CaseIterable, Codable {
    
    case caddy, rider, dayWorker
    
    public init(title: String) {
        switch title {
        case Self.caddy.title:
            self = .caddy
        case Self.rider.title:
            self = .rider
        case Self.dayWorker.title:
            self = .dayWorker
        default:
            self = .caddy
        }
    }
    
    public var title: String {
        switch self {
        case .caddy:
            return "골프캐디"
        case .rider:
            return "배달 라이더"
        case .dayWorker:
            return "일용직 근로자"
        }
    }
}
