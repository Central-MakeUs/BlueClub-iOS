//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI

public extension Image {
    
    static func icons(_ icon: Icons) -> Image {
        .init(icon.rawValue, bundle: .module)
    }
}
