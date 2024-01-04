//
//  File.swift
//  
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func fontModifer(_ typo: Fonts) -> some View {
        ModifiedContent(content: self, modifier: FontModifier(typo))
    }
}
