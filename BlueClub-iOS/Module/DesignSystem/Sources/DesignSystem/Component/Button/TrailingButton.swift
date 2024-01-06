//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct TrailingButton: View {
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    public init(
        title: String,
        isActive: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isActive = isActive
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .foregroundStyle(Color.white)
                .fontModifer(.sb3)
                .frame(height: 18)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    isActive
                    ? Color.colors(.cg10)
                    : Color.colors(.gray04)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }).disabled(!isActive)
    }
}

#Preview {
    VStack {
        TrailingButton(title: "중복확인", isActive: true, action: { })
        TrailingButton(title: "중복확인", isActive: false, action: { })
    }
}
