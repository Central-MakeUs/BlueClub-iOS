//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct AccessoryButton: View {
    
    let title: String
    let foreground: Color
    let background: Color
    let border: Color?
    let trailingAccessory: Icons
    let hPadding: CGFloat
    let action: () -> Void
    
    public init(
        title: String,
        foreground: Color = .colors(.gray09),
        background: Color = .colors(.white),
        border: Color? = .colors(.gray04),
        trailingAccessory: Icons = .arrow_bottom,
        hPadding: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.foreground = foreground
        self.background = background
        self.border = border
        self.trailingAccessory = trailingAccessory
        self.hPadding = hPadding
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 0) {
                Text(title)
                Spacer(minLength: 0)
                trailingAccessory.image
                    .resizable()
                    .fixedSize()
                    .frame(width: 20, height: 20)
            }
            .fontModifer(.sb1)
            .foregroundStyle(foreground)
            .padding(.horizontal, 24)
            .frame(height: 56)
            .background(background)
            .if(border != nil) {
                $0.overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(border!, lineWidth: 1.0)
                }
            }
            .cornerRadius(12)
            .padding(.horizontal, hPadding)
        })
    }
}

#Preview {
    AccessoryButton(
        title: "근무 시작년도를 선택해주세요",
        action: { }
    )
}
