//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI

public struct SheetCellRow: View {
    
    let title: String
    
    public init(title: String) {
        self.title = title
    }
    public var body: some View {
        Text(title)
            .fontModifer(.b1m)
            .foregroundStyle(Color.colors(.gray07))
            .frame(height: 56)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .drawUnderline(.colors(.gray02))
            .padding(.horizontal, 20)
    }
}

#Preview {
    SheetCellRow(title: "Hello")
}
