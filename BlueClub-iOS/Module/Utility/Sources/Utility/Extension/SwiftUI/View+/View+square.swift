//
//  File.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func square(_ size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}
