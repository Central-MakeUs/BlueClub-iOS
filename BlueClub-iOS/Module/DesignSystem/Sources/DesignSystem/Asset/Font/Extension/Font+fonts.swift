//
//  File.swift
//  
//
//  Created by 김인섭 on 1/3/24.
//

import SwiftUI

public extension Font {
    
    static func fonts(_ font: Fonts) -> Font {
        .init(UIFont.pretendard(font.pretendard, size: font.size))
    }
}
