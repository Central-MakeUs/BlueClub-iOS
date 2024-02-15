//
//  File.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func loadingSpinner(_ condition: Bool) -> some View {
        self.overlay {
            if condition {
                LoadingSpinner()
            }
        }
    }
}
