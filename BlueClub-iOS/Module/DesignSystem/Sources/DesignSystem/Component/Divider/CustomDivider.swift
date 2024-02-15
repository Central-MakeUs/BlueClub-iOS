//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public struct CustomDivider: View {
    
    let color: Color
    let height: CGFloat
    let padding: CGFloat
    
    public init(
        color: Color = .colors(.cg03),
        height: CGFloat = 1,
        padding: CGFloat = 4
    ) {
        self.color = color
        self.height = height
        self.padding = padding
    }
    
    public var body: some View {
        Rectangle()
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.vertical, padding)
    }
}
