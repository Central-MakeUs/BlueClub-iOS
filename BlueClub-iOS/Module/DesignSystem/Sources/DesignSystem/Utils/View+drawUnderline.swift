//
//  File.swift
//  
//
//  Created by 김인섭 on 1/22/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func drawUnderline(
        _ color: Color = Color.colors(.gray04),
        height: CGFloat = 1,
        vPadding: CGFloat = 0
    ) -> some View {
        self.overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(color)
        }
    }
}
