//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func syncFocused<T: Equatable>(
        _ focusState: FocusState<T?>.Binding,
        with binding: Binding<T?>
    ) -> some View {
        self
            .onChange(of: focusState.wrappedValue) {
                binding.wrappedValue = $0
            }
            .onChange(of: binding.wrappedValue) {
                focusState.wrappedValue = $0
            }
    }
    
    @ViewBuilder func hideKeyboardOnTapBackground() -> some View {
        self
            .background(
                Color(UIColor.systemBackground)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
            )
    }
}
