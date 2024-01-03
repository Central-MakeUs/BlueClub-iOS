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
                .designedFont(.h1)
            
            Text("Hello Word")
                .designedFont(.h2)

            Text("Hello Word")
                .designedFont(.sb1(.bold))
            
            Text("Hello Word")
                .designedFont(.sb1(.semiBold))
        }
    }
}

#Preview {
    SwiftUIView()
}
