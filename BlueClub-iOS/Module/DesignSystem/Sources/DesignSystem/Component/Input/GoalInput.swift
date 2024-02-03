//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI

public struct GoalInput<T: Hashable>: View {
    
    @Binding var text: String
    let message: (String, Color)?
    let focusState: FocusState<T?>.Binding
    let focusValue: T
    
    public init(
        text: Binding<String>,
        message: (String, Color)?,
        focusState: FocusState<T?>.Binding,
        focusValue: T
    ) {
        self._text = text
        self.message = message
        self.focusState = focusState
        self.focusValue = focusValue
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused(focusState, equals: focusValue)
                Text("원")
                    .hide(when: text.isEmpty)
            }
            .fontModifer(.b1)
            .frame(height: 24)
            .foregroundStyle(Color.colors(.gray10))
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(alignment: .trailing, content: {
                if text.isEmpty {
                    Text("목표 금액 입력")
                        .fontModifer(.b1)
                        .foregroundStyle(Color.colors(.gray06))
                        .padding(.trailing, 12)
                }
            })
            .roundedBackground(
                .colors(.gray01),
                radius: 8
            )
            if let message {
                Text(message.0)
                    .fontModifer(.caption1)
                    .foregroundStyle(message.1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(height: 18)
                    .padding(.horizontal, 8)
            }
        }.padding(.horizontal, 20)
    }
}

//#Preview {
//    GoalInput(
//        text: .init(projectedValue: ""),
//        message: <#T##(String, Color)?#>,
//        focusState: .init(,
//        focusValue: true)
//}
