//
//  MemoSheet.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import DesignSystem

struct MemoSheet: View {
    
    @Binding var isPresented: Bool
    @Binding var text: String
    @FocusState var focus
    
    var body: some View {
        BaseView {
            header()
        } content: {
            TextEditor(text: $text)
                .padding(.horizontal, 30)
                .focused($focus)
        }.onAppear { focus = true }

    }
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 0) {
            SheetHandle()
            HStack {
                Text("메모")
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.gray10))
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    Image.icons(.x)
                }).buttonStyle(.plain)
            }
            .frame(height: 28)
            .padding(.horizontal, 30)
            .padding(.bottom, 14)
        }
    }
}

#Preview {
    MemoSheet(isPresented: .constant(true), text: .constant(""))
}
