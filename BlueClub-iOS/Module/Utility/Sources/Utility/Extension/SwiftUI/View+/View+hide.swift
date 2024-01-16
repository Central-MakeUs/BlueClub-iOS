//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func hide(when shouldHide: Bool) -> some View {
        if !shouldHide {
            self
        } 
    }
}
