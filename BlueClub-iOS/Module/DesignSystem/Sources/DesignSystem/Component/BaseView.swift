//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import Utility

public struct BaseView<Header: View, Content: View, Footer: View>: View {
    
    let header: Header
    let content: Content
    let footer: Footer
    
    public init(
        header: () -> Header = { EmptyView() },
        content: () -> Content,
        footer: () -> Footer = { EmptyView() }
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            header
            content
            Spacer(minLength: 0)
            footer
        }.hideKeyboardOnTapBackground()
    }
}

#Preview {
    BaseView {
        HStack {
            Image.icons(.arrow_left)
            Spacer()
        }
        .frame(height: 28)
        .padding(12)
        .overlay {
            Text("Hello")
        }
    } content: {
        Text("Hello")
    }

}
