//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public struct RadiusRectangle: View {
    
    let color: Color
    let height: CGFloat
    let radius: CGFloat
    
    public init(
        _ color: Color,
        height: CGFloat,
        radius: CGFloat
    ) {
        self.color = color
        self.height = height
        self.radius = radius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .frame(height: height)
            .foregroundStyle(color)
    }
}
