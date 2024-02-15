//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/27/24.
//

import SwiftUI

public struct ChipView: View {
    
    let title: String
    let style: Style
    
    public init(
        _ title: String,
        style: Style = .blue
    ) {
        self.title = title
        self.style = style
    }
    public var body: some View {
        Text(title)
            .fontModifer(.sb3)
            .foregroundStyle(style.foreground)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .roundedBackground(
                style.background,
                radius: 4)
    }
}

extension ChipView {
    
    public enum Style {
        case blue, red, gray
        
        var foreground: Color {
            switch self {
            case .blue:
                return .colors(.primaryNormal)
            case .red:
                return .colors(.error)
            case .gray:
                return .colors(.cg06)
            }
        }
        
        var background: Color {
            switch self {
            case .blue:
                return .colors(.primaryBackground)
            case .red:
                return .init(hex: "FFF1F1")
            case .gray:
                return .colors(.cg02)
            }
        }
    }
}

#Preview {
    ChipView("자동계산")
}
