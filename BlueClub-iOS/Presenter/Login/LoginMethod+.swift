//
//  LoginMethod.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI
import DesignSystem
import Domain

extension LoginMethod {
    
    var buttonTitle: String {
        switch self {
        case .kakao:
            return "카카오로 3초만에 시작하기"
        case .naver:
            return "네이버로 시작하기"
        case .apple:
            return "애플로 시작하기"
        }
    }
    
    var foreground: Color {
        switch self {
        case .kakao:
            return .init(hex: "3C1E1E")
        case .naver:
            return .colors(.white)
        case .apple:
            return .colors(.white)
        }
    }
    
    var background: Color {
        switch self {
        case .kakao:
            return .init(hex: "FDE500")
        case .naver:
            return .init(hex: "03C75A")
        case .apple:
            return .colors(.black)
        }
    }
    
    var icon: Icons? {
        switch self {
        case .kakao:
            return .kakao
        case .naver:
            return .naver
        case .apple:
            return .apple
        }
    }
}
