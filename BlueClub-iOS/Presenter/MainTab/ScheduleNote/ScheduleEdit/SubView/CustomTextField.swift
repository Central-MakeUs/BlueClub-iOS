//
//  CustomTextField.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/7/24.
//

import SwiftUI
import DesignSystem

struct CustomTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(text: $text) {
            Text(placeholder)
                .foregroundStyle(Color.colors(.gray04))
        }
        .multilineTextAlignment(.trailing)
        .fontModifer(.b1m)
        .foregroundStyle(Color.colors(.gray10))
    }
}

#Preview {
    CustomTextField(text: .constant(""), placeholder: "근무 현장명 입력")
}
