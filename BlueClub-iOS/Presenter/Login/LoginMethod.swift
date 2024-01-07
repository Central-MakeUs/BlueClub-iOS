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
        case .apple:
            return "애플로 시작하기"
        case .email:
            return "이메일로 시작하기"
        }
    }
    
    var foreground: Color {
        switch self {
        case .kakao:
            .init(hex: "3C1E1E")
        case .apple:
            .colors(.white)
        case .email:
            Color.colors(.gray06)
        }
    }
    
    var background: Color {
        switch self {
        case .kakao:
            .init(hex: "FDE500")
        case .apple:
            .colors(.black)
        case .email:
            .clear
        }
    }
    
    var icon: Icons? {
        switch self {
        case .kakao:
            return .kakao
        case .apple:
            return .apple
        case .email:
            return .none
        }
    }
}
