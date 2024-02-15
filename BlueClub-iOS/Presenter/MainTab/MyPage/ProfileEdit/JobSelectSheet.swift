//
//  JobSelectSheet.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import Domain
import DesignSystem

struct JobSelectSheet: View {
    
    @Binding var isShow: Bool
    let onSelect: (JobOption) -> Void
    
    init(
        isShow: Binding<Bool>,
        onSelect: @escaping (JobOption) -> Void
    ) {
        self._isShow = isShow
        self.onSelect = onSelect
    }
    
    var body: some View {
        BaseView {
            SheetHeader(
                title: "직업을 선택해주세요",
                dismiss: { isShow = false })
        } content: {
            VStack {
                ForEach(JobOption.allCases, id: \.self) { option in
                    Button(action: {
                        onSelect(option)
                        isShow = false
                    }, label: {
                        SheetCellRow(title: option.title)
                    })
                }
            }
        }

    }
}

#Preview {
    JobSelectSheet(
        isShow: .constant(true),
        onSelect: { _ in })
}
