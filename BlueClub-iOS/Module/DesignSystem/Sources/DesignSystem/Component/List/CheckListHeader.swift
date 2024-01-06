//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI

public struct CheckListHeader: View {
    
    let hasCheck: Bool
    let title: String
    let onTapCell: () -> Void
    
    public init(
        hasCheck: Bool,
        title: String,
        onTap: @escaping () -> Void
    ) {
        self.hasCheck = hasCheck
        self.title = title
        self.onTapCell = onTap
    }
    
    public var body: some View {
        Button(action: {
            onTapCell()
        }, label: {
            HStack(spacing: 12) {
                Icons.check_circle_solid.image
                    .foregroundStyle(
                        hasCheck
                        ? Color.colors(.primaryNormal)
                        : Color.colors(.gray04)
                    )
                Text(title)
                    .foregroundStyle(Color(hex: "232323"))
                    .fontModifer(.sb1)
                Spacer()
            }
            .padding(16)
            .background(Color.colors(.gray01))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .frame(height: 56)
        })
    }
}

#Preview {
    CheckListHeader(
        hasCheck: true,
        title: "약관 전체 동의",
        onTap: { }
    )
}
