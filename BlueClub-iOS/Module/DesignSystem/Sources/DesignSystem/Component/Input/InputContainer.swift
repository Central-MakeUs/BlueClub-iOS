//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct InputContainer<Content: View>: View {
    
    let title: (String, Bool)? // title text, star icon
    let content: Content
    
    public init(
        title: (String, Bool)? = .none,
        content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            if let title {
                HStack(spacing: 0) {
                    Text(title.0)
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.colors(.gray09))
                    if title.1 {
                        Text("*")
                            .foregroundStyle(Color.colors(.error))
                            .font(.pretendard(.medium, size: 14))
                    }
                    Spacer()
                }.frame(height: 14)
            }
            content
                .padding(.vertical, 4)
                .background(Color.colors(.gray01))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
    }
}
