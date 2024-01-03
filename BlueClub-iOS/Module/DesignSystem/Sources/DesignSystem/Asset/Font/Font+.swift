//
//  File.swift
//  
//
//  Created by 김인섭 on 1/3/24.
//

import SwiftUI

public extension Font {
    
    static func designSystem(_ font: FontSystem) -> Font {
        Font(font.uiFont)
    }
}
