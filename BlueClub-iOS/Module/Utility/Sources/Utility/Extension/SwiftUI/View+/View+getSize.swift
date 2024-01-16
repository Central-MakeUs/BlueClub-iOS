//
//  File.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func getSize(_ size: @escaping (CGSize) -> Void ) -> some View {
        self.background {
            GeometryReader { geometry in
                Color.clear.onAppear {
                    size(geometry.size)
                }
            }
        }
    }
}
