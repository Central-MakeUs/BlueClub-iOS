//
//  File.swift
//  
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

public struct FontModifier: ViewModifier {
    
    private let font: FontSystem
    private var fontHeight: CGFloat { font.uiFont.lineHeight }
    private var lineHeight: CGFloat { font.lineHeight }
    
    public init(_ font: FontSystem) {
        self.font = font
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.designSystem(font))
            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, (lineHeight - fontHeight) / 2)
            .tracking(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
    }
}

public extension View {
    
    @ViewBuilder func designedFont(_ font: FontSystem) -> some View {
        ModifiedContent(content: self, modifier: FontModifier(font))
    }
}
