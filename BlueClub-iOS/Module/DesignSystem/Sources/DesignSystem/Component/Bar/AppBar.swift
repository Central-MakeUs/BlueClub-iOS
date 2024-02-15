//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

public struct AppBar: View {
    
    let leadingIcon: (Icons, () -> Void)
    let title: String?
    let trailingIcon: (Icons, () -> Void)?
    let isTrailingButtonActive: Bool
    let trailingButton: (String, () -> Void)?
    
    public init(
        leadingIcon: (Icons, () -> Void),
        title: String?,
        trailingIcon: (Icons, () -> Void)? = .none,
        isTrailingButtonActive: Bool = true,
        trailingButton: (String, () -> Void)? = .none
    ) {
        self.leadingIcon = leadingIcon
        self.title = title
        self.trailingIcon = trailingIcon
        self.isTrailingButtonActive = isTrailingButtonActive
        self.trailingButton = trailingButton
    }
    
    public var body: some View {
        HStack {
            Button(action: {
                leadingIcon.1()
            }, label: {
                Image.icons(leadingIcon.0)
            }).buttonStyle(PlainButtonStyle())
            Spacer()
            if let trailingIcon {
                Button(action: {
                    trailingIcon.1()
                }, label: {
                    Image.icons(trailingIcon.0)
                }).buttonStyle(PlainButtonStyle())
            }
            if let trailingButton {
                Button {
                    trailingButton.1()
                } label: {
                    Text(trailingButton.0)
                        .fontModifer(.sb1)
                        .foregroundStyle(Color.colors(
                            isTrailingButtonActive
                            ? .primaryNormal
                            : .gray05
                        ))
                }
            }
        }
        .frame(height: 28)
        .padding(12)
        .overlay {
            if let title {
                Text(title)
                    .fontModifer(.sb1)
            }
        }
    }
}

#Preview {
    AppBar(
        leadingIcon: (Icons.arrow_left, { }),
        title: "설정"
    )
}
