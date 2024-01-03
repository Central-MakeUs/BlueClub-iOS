//
//  SwiftUIView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/3/24.
//

import SwiftUI
import DesignSystem

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("Hello Word")
                .font(.typography(.b1))
            Text("Hello Word")
                .typography(.b1)
        }
    }
}

#Preview {
    SwiftUIView()
    
}
