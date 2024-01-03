//
//  File.swift
//  
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

struct TypographyModifier: ViewModifier {
    
    private let typo: Typography
    private var fontHeight: CGFloat { typo.uiFont.lineHeight }
    private var lineHeight: CGFloat { typo.lineHeight }
    
    init(_ typo: Typography) {
        self.typo = typo
    }
    
    func body(content: Content) -> some View {
        content
            .font(.typography(typo))
            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, (lineHeight - fontHeight) / 2)
            .tracking(typo.letterSpacing)
    }
}
