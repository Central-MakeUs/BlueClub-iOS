//
//  StartYearSelectView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct SelectYearView: View {
    
    @Binding var isPresented: Bool
    @Binding var selectedYear: Int?
    
    static let viewHeight: CGFloat = 460
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        BaseView {
            SheetHeader(
                dismiss: { isPresented = false },
                title: "근무 시작년도 선택")
        } content: {
            content()
        }.frame(height: Self.viewHeight)
    }
    
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(content: {
                ForEach(0...100, id: \.self) { count in
                    let year = currentYear - count
                    Button(action: {
                        self.selectedYear = year
                        self.isPresented = false
                    }, label: {
                        ListCell(
                            title: String(year),
                            isSelected: selectedYear == year
                        )
                    })
                }
            })
        }
    }
}

