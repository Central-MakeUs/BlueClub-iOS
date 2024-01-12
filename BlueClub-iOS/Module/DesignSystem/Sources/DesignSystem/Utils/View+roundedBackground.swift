//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func roundedBackground(
        _ color: Color = .white,
        radius: CGFloat = 12
    ) -> some View {
        self
            .background { color }
            .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

