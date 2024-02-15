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
                Image.icons(hasCheck ? .check_active : .check_deactive)
                    .padding(.leading, 3)
                Text(title)
                    .foregroundStyle(Color.colors(.gray10))
                    .fontModifer(.sb1)
                Spacer()
            }
            .padding(.vertical, 16)
            .drawUnderline()
            .padding(.horizontal, 30)
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
