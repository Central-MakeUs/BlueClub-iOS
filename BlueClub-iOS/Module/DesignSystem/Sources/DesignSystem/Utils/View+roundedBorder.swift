//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func roundedBorder(
        _ color: Color = .colors(.cg03),
        radius: CGFloat = 12,
        lineWidth: CGFloat = 1.0
    ) -> some View {
        self.overlay {
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: lineWidth)
        }
    }
}
