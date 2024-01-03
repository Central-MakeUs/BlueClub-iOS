//
//  File.swift
//  
//
//  Created by 김인섭 on 1/3/24.
//

import SwiftUI

public extension Font {
    
    static func typography(_ typo: Typography) -> Font {
        .init(UIFont.pretendard(typo.font, size: typo.size))
    }
}