//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import Utility

public struct PrimaryButton: View {
    
    let title: String
    let disabled: Bool
    let type: ButtonType
    let action: () -> Void

    public init(
        title: String,
        disabled: Bool = false,
        type: ButtonType = .filled,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.disabled = disabled
        self.type = type
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
        }).ifElse(type == .filled, {
            $0.buttonStyle(FilledButtonStyle(disabled: disabled))
        }, {
            $0.buttonStyle(OutlineButtonStyle(disabled: disabled))
        })
    }
}

extension PrimaryButton {
    
    struct FilledButtonStyle: ButtonStyle {
        
        let disabled: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .fontModifer(.sb1)
                .foregroundStyle(Color.colors(.white))
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    disabled
                    ? Color.colors(.gray04)
                    : configuration.isPressed
                    ? Color.colors(.primaryDark)
                    : Color.colors(.primaryNormal)
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)
        }
    }

    struct OutlineButtonStyle: ButtonStyle {
        
        let disabled: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .fontModifer(.sb1)
                .foregroundStyle(
                    disabled
                    ? Color.colors(.gray06)
                    : configuration.isPressed
                    ? Color.colors(.primaryDark)
                    : Color.colors(.primaryNormal)
                )
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(Color.colors(.white))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            disabled
                            ? Color.colors(.gray04)
                            : configuration.isPressed
                            ? Color.colors(.primaryDark)
                            : Color.colors(.primaryNormal),
                            lineWidth: 1.0
                        )
                })
                .cornerRadius(12)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PrimaryButton(
        title: "직업 설정하고 시작하기",
        disabled: true,
        action: { }
    )
}
