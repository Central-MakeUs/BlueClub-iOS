//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import Utility

public struct TextInput<T: Hashable>: View {
    
    @Binding var text: String
    let placeholder: String
    
    let focusState: FocusState<T?>.Binding
    let focusValue: T
    
    public init(
        text: Binding<String>,
        placeholder: String,
        focusState: FocusState<T?>.Binding,
        focusValue: T
    ) {
        self._text = text
        self.placeholder = placeholder
        self.focusState = focusState
        self.focusValue = focusValue
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField(text: $text) {
                Text(placeholder)
                    .fontModifer(.b1)
            }
            .focused(focusState, equals: focusValue)
            .foregroundStyle(Color.colors(.gray05))
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image.icons(.close_circle)
                })
            }
        }
        .padding(16)
        .frame(height: 56)
        .background(Color.colors(.gray01))
        .cornerRadius(12)
    }
}
