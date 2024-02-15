//
//  File.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func syncState<T: Equatable>(
        _ state: Binding<T>,
        sync: Binding<T>,
        animation: Animation? = .default
    ) -> some View {
        self.onChange(of: state.wrappedValue) { newValue in
            if let animation {
                withAnimation(animation) {
                    sync.wrappedValue = newValue
                }
            }
        }.onChange(of: sync.wrappedValue) { newValue in
            if let animation {
                withAnimation(animation) {
                    state.wrappedValue = newValue
                }
            }
        }
    }
}
