//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct SheetHeader: View {
    
    let title: String
    let description: String?
    let dismiss: () -> Void
    
    public init(
        title: String,
        description: String? = .none,
        dismiss: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.dismiss = dismiss
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.gray10))
                    .lineLimit(2)
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image.icons(.x)
                        .foregroundStyle(Color.colors(.gray10))
                }
            }
            if let description {
                Text(description)
                    .fontModifer(.b2m)
                    .foregroundStyle(Color(hex: "7C7C7C"))
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 32)
        .padding(.bottom, 14)
    }
}

#Preview {
    SheetHeader(
        title: "블루 피플을 이용하려면,\n정보 동의가 필요해요.",
        dismiss: { }
    )
}
