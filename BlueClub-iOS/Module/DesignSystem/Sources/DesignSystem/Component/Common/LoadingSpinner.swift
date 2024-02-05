//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI

struct LoadingSpinner: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.2)
            .padding(50)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LoadingSpinner()
}
