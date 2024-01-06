//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public struct SheetHeader: View {
    
    let dismiss: () -> Void
    let title: String
    
    public init(
        dismiss: @escaping () -> Void,
        title: String
    ) {
        self.dismiss = dismiss
        self.title = title
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Button(action: {
                dismiss()
            }, label: {
                Icons.x.image
            }).buttonStyle(PlainButtonStyle())
            Text(title)
                .foregroundStyle(Color(hex: "181818"))
                .fontModifer(.h6)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 30)
        .padding(.trailing, 20)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }
}

#Preview {
    SheetHeader(
        dismiss: {},
        title: "블루 피플을 이용하려면,\n정보 동의가 필요해요."
    )
}
