//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct CustomButton: View {
    
    let leadingIcon: Icons?
    let title: String
    let foreground: Color
    let background: Color
    let border: Color?
    let action: () -> Void
    
    public init(
        leadingIcon: Icons? = .none,
        title: String,
        foreground: Color,
        background: Color,
        border: Color? = .none,
        action: @escaping () -> Void
    ) {
        self.leadingIcon = leadingIcon
        self.title = title
        self.foreground = foreground
        self.background = background
        self.border = border
        self.action = action
    }
    
    public var body: some View {
        
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 4) {
                if let leadingIcon {
                    leadingIcon.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(title)
            }
            .fontModifer(.sb2)
            .foregroundStyle(foreground)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(background)
            .if(border != nil, {
                $0.overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(border!, lineWidth: 1.0)
                }
            })
            .cornerRadius(12)
            .padding(.horizontal, 20)
        })
    }
}

#Preview {
    CustomButton(
        title: "카카오로 3초만에 가입하기",
        foreground: Color.colors(.black),
        background: Color(hex: "FDE500"),
        action: { }
    )
//    CustomButton(
//        title: "근무 시작년도를 선택해주세요",
//        foreground: .colors(.gray09),
//        background: .colors(.white),
//        action: { }
//    )
}
