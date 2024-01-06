//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct GrayButton: View {
    
    let title: String
    let disabled: Bool
//    let type: ButtonType
    let action: () -> Void

    public init(
        title: String,
        disabled: Bool = false,
//        type: ButtonType = .filled,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.disabled = disabled
//        self.type = type
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
        })
        .buttonStyle(FilledButtonStyle(disabled: disabled))
    }
}

extension GrayButton {
    
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
                    ? Color.colors(.cg09)
                    : Color.colors(.cg10)
                )
                .cornerRadius(12)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    GrayButton(
        title: "직업 설정하고 시작하기",
        disabled: true,
        action: { }
    )
}
