//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import Utility

public struct TextInput<T: Hashable, Content: View>: View {
    
    @Binding var text: String
    let placeholder: String
    let hasDivider: Bool
    let timerText: String?
    let trailingButton: () -> Content
    
    let focusState: FocusState<T?>.Binding
    @Binding var followingState: T?
    let focusValue: T
    
    public init(
        text: Binding<String>,
        placeholder: String,
        
        focusState: FocusState<T?>.Binding,
        followingState: Binding<T?> = .constant(false),
        focusValue: T,
        
        hasDivider: Bool = false,
        timerText: String? = .none,
        trailingButton: @escaping () -> Content = { EmptyView() }
    ) {
        self._text = text
        self.placeholder = placeholder
        self.hasDivider = hasDivider
        self.timerText = timerText
        self.trailingButton = trailingButton
        
        self.focusState = focusState
        self._followingState = followingState
        self.focusValue = focusValue
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField(text: $text) {
                Text(placeholder)
                    .fontModifer(.b1m)
                    .foregroundStyle(Color.colors(.gray05))
            }
            .focused(focusState, equals: focusValue)
            .syncFocused(focusState, with: $followingState)
            
            if let timerText {
                Text(timerText)
                    .fontModifer(.b2m)
                    .foregroundStyle(Color(hex: "EF3333"))
                    .frame(height: 20)
                    .padding(.bottom, 2)
            }
            
            trailingButton()
        }
        .padding(16)
        .frame(height: 56)
        .background(Color.colors(.gray01))
        .cornerRadius(12)
        .overlay(alignment: .bottom) {
            if hasDivider {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.colors(.gray03))
                    .padding(.horizontal, 16)
            }
        }
    }
}
