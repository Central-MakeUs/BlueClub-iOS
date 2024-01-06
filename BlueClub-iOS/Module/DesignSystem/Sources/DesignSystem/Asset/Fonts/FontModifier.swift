//
//  File.swift
//  
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

struct FontModifier: ViewModifier {
    
    private let font: Fonts
    private var fontHeight: CGFloat {
        UIFont.pretendard(
            font.pretendard,
            size: font.size
        ).lineHeight
    }
    private var lineHeight: CGFloat {
        font.lineHeight
    }
    
    init(_ font: Fonts) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        content
            .font(.fonts(font))
            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, (lineHeight - fontHeight) / 2)
            .tracking(font.letterSpacing)
    }
}
