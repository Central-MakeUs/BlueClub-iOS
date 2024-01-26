//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI

public struct CheckListCell: View {
    
    let hasCheck: Bool
    let title: String
    let onTapCheck: () -> Void
    
    public init(
        hasCheck: Bool,
        title: String,
        onTapCheck: @escaping () -> Void
    ) {
        self.hasCheck = hasCheck
        self.title = title
        self.onTapCheck = onTapCheck
    }
    
    public var body: some View {
        HStack {
            HStack(spacing: 6) {
                Button {
                    onTapCheck()
                } label: {
                    Image.icons(hasCheck ? .check_active : .check_deactive)
                }
                Text(title)
                    .fontModifer(.b2m)
                    .foregroundStyle(Color.colors(.gray07))
            }
            Spacer()
            Icons.arrow_right.image
                .foregroundStyle(Color.colors(.gray05))
        }
        .background(Color.white)
        .frame(height: 24)
        .padding(.horizontal, 33)
    }
}

#Preview {
    Button(action: {
        print("cell tap")
    }, label: {
        CheckListCell(
            hasCheck: true,
            title: "개인정보 수집·이용 정책 동의 (필수)",
            onTapCheck: { print("check tap") }
        )
    })
}
