//
//  SelectTelecomView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import DesignSystem

struct SelectTelecomView: View {
    
    @Binding var isPresented: Bool
    @Binding var selected: Telecom?
    
    var body: some View {
        BaseView {
            SheetHeader(
                dismiss: { self.isPresented = false },
                title: "통신사 선택")
        } content: {
            VStack(spacing: 0) {
                ForEach(Telecom.allCases, id: \.title) { telecom in
                    Button(action: {
                        self.selected = telecom
                        self.isPresented = false
                    }, label: {
                        ListCell(
                            title: telecom.title,
                            isSelected: self.selected == telecom
                        )
                    })
                }
            }
        }
    }
}

extension SelectTelecomView {
    enum Telecom: CaseIterable {
        case skt, kt, lg, skt알뜰, kt알뜰, lg알뜰
        
        var title: String {
            switch self {
            case .skt:
                return "SKT"
            case .kt:
                return "KT"
            case .lg:
                return "LG U+"
            case .skt알뜰:
                return "SKT 알뜰폰"
            case .kt알뜰:
                return "KT 알뜰폰"
            case .lg알뜰:
                return "LG U+ 알뜰폰"
            }
        }
    }
}

#Preview {
    SelectTelecomView(
        isPresented: .constant(true),
        selected: .constant(.none)
    )
}
