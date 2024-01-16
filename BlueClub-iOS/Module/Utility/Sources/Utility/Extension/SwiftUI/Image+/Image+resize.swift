//
//  File.swift
//  
//
//  Created by 김인섭 on 1/14/24.
//

import SwiftUI

public extension Image {
    
    @ViewBuilder func resizeWidth(_ width: CGFloat) -> some View {
        self.resizable()
            .scaledToFit()
            .ifElse(width == .infinity, {
                $0.frame(maxWidth: .infinity)
            }, {
                $0.frame(width: width)
            })
    }
}
