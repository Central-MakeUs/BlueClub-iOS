//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI

public struct TitleBar: View {
    
    let title: String?
    let trailingIcons: [(Icons, () -> Void)]
    
    public init(
        title: String? = .none,
        trailingIcons: [(Icons, () -> Void)]
    ) {
        self.title = title
        self.trailingIcons = trailingIcons
    }
    
    
    public var body: some View {
        HStack(spacing: 16) {
            if let title {
                Text(title)
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.gray10))
            } else {
                Image(.blueClub)
            }
            Spacer()
            ForEach(trailingIcons, id: \.0) { icon in
                Button(action: {
                    icon.1()
                }, label: {
                    icon.0.image
                        .foregroundStyle(Color.colors(.cg05))
                })
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 20)
    }
}

#Preview {
    TitleBar(
        title: "근무수첩",
        trailingIcons: [
            (Icons.add_large, { }),
            (Icons.notification1_large, { })
        ]
    )
}
