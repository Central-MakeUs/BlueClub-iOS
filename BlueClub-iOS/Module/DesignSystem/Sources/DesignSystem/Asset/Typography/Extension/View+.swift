//
//  File.swift
//  
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func typography(_ typo: Typography) -> some View {
        ModifiedContent(content: self, modifier: TypographyModifier(typo))
    }
}
