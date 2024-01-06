//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct ListCell: View {
    
    let title: String
    let isSelected: Bool
    
    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    public var body: some View {
        HStack(content: {
            Text(title)
                .fontModifer(.b1m)
                .foregroundStyle(
                    isSelected
                    ? Colors.primaryNormal.color
                    : Color(hex: "181818")
                )
            Spacer()
            if isSelected {
                Icons.checkpx.image
                    .foregroundStyle(
                        Colors.primaryNormal.color
                    )
            }
        })
        .padding(.horizontal, 30)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(hex: "EFEFEF"))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ListCell(title: "SKT", isSelected: false)
}
